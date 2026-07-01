import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../features/worker/my_application_jobs/data/models/my_jobs_response.dart';
import '../widget/enums.dart';
import 'dart:developer';
part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final SocketService _socketService;
  static const String _shiftStatusKey = 'shift_status_';
  static const String _lastShiftDateKey = 'last_shift_date_';

  ShiftCubit(this._socketService) : super(ShiftLoading());

  late MyJobItem _currentItem;
  late String _currentJobId;
  late String _currentAppId;
  late String _currentRole;
  late ShiftStatus _currentStatus;

  String get currentJobId => _currentJobId;
  String get currentAppId => _currentAppId;

  void initShiftDetails(MyJobItem item, {required UserRole role}) async {
    _currentItem = item;
    _currentJobId = item.job?.id ?? '';
    _currentAppId = item.applicationId ?? '';
    _currentRole = role == UserRole.worker ? 'worker' : 'employer';

    log('🔧 ========== INIT SHIFT DETAILS ==========');
    log('🔧 _currentJobId: $_currentJobId');
    log('🔧 _currentAppId (before fetch): $_currentAppId');
    log('🔧 _currentRole: $_currentRole');

    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    final userId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);

    // ✅ جلب البيانات الكاملة من GET /jobs/{jobId}
    try {
      final dio = getIt<Dio>();
      final response = await dio.get(
        '${ApiConstants.apiBaseUrl}jobs/$_currentJobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['data'] as Map<String, dynamic>?;
      if (data != null) {
        final jobData = data['job'] as Map<String, dynamic>?;
        final applications = data['applications'] as List?;
        final myApplication = data['myApplication'] as Map<String, dynamic>?;

        if (jobData != null) {
          final updatedJob = JobDetails.fromJson(jobData);
          _currentItem = MyJobItem(
            id: item.id,
            title: item.title,
            place: item.place,
            postedAt: item.postedAt,
            finalStatus: item.finalStatus,
            jobStatus: item.jobStatus,
            job: updatedJob,
            applicationStatus: item.applicationStatus,
            arrivalStatus: item.arrivalStatus,
            appliedAt: item.appliedAt,
            applicationId: item.applicationId,
          );
        }

        if (_currentRole == 'employer' && applications != null && applications.isNotEmpty) {
          final firstApp = applications.first as Map<String, dynamic>?;
          if (firstApp != null) {
            final appId = firstApp['_id'] as String?;
            if (appId != null && appId.isNotEmpty) {
              _currentAppId = appId;
              log('🔧 Updated appId from applications: $_currentAppId');
            }
          }
        } else if (_currentRole == 'worker' && myApplication != null) {
          final appId = myApplication['_id'] as String?;
          if (appId != null && appId.isNotEmpty) {
            _currentAppId = appId;
            log('🔧 Updated appId from myApplication: $_currentAppId');
          }
        }
      }
    } catch (e) {
      log('❌ Failed to fetch full job details: $e');
    }

    if (_currentRole == 'employer' && _currentAppId.isEmpty) {
      _currentAppId = await _fetchApplicationIdForJob();
      log('🔧 _currentAppId (fallback fetch): $_currentAppId');
    }

    log('🔧 =========================================');

    // ✅ 1. التحقق من اليوم الجديد وإعادة تعيين الحالة
    await _checkAndResetForNewDay();

    // ✅ 2. تحميل الحالة من Preferences
    _currentStatus = await _loadStatusFromPreferences();
    log('📊 Loaded from preferences: $_currentStatus');

    // ✅ 3. إذا كانت notStarted، ابدأ من الصفر
    if (_currentStatus == ShiftStatus.notStarted) {
      log('📊 Starting fresh - status remains notStarted');
      await _saveStatusToPreferences(ShiftStatus.notStarted);
    }

    emit(ShiftLoaded(
      item: _currentItem,
      status: _currentStatus,
      role: role,
    ));

    _socketService.joinJobRoom(_currentJobId);
    if (userId.isNotEmpty) {
      _socketService.joinUserRoom(userId);
      log('👤 User joined user room: $userId');
    }

    _listenToSocketEvents();
  }

  // ✅ جلب applicationId للـ Employer من API (Fallback)
  Future<String> _fetchApplicationIdForJob() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      final dio = getIt<Dio>();

      log('📡 Fetching applicationId for jobId: $_currentJobId');

      final response = await dio.get(
        '${ApiConstants.apiBaseUrl}applications/jobs/$_currentJobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data['data'] as List?;
      if (data != null && data.isNotEmpty) {
        final appId = data.first['_id'] as String? ?? '';
        log('📡 ✅ Fetched applicationId: $appId');
        return appId;
      } else {
        log('📡 ❌ No applications found for jobId: $_currentJobId');
      }
    } catch (e) {
      log('📡 ❌ Failed to fetch applicationId: $e');
    }
    return '';
  }

  // أضف هذه الدالة في ShiftCubit
  void markShiftCompleted() {
    // ✅ حفظ الحالة كـ completed في Preferences
    _updateStatus(ShiftStatus.completed);

    // ✅ إعادة تعيين اليوم لليوم التالي
    _checkAndResetForNewDay();
  }
  Future<void> _checkAndResetForNewDay() async {
    final job = _currentItem.job;
    if (job?.startDateTime == null) return;

    final startTime = DateTime.parse(job!.startDateTime!);
    final now = DateTime.now();
    final endDateTime = job.endDateTime != null && job.endDateTime!.isNotEmpty
        ? DateTime.parse(job.endDateTime!)
        : startTime.add(Duration(days: 30));

    // ✅ حساب وقت البدء لليوم الحالي
    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
      startTime.second,
    );

    // ✅ جلب آخر يوم تم فيه تحديث الحالة (باستخدام jobId بدلاً من appId)
    final prefs = await SharedPreferences.getInstance();
    final lastUpdateDate = prefs.getString('${_lastShiftDateKey}${_currentJobId}');

    final todayKey = '${now.year}-${now.month}-${now.day}';

    // ✅ التحقق: هل النهارده يوم جديد مختلف عن آخر تحديث؟
    final bool isNewDay = lastUpdateDate != todayKey;

    // ✅ التحقق: هل الشيفت لسه في نطاق الأيام؟
    final bool isWithinShiftDays = now.isBefore(endDateTime);

    // ✅ التحقق: هل وقت البدء لسه مجاش اليوم؟
    final bool isBeforeStartTime = now.isBefore(todayStart);

    if (isNewDay && isWithinShiftDays) {
      log('🔄 New day detected! Resetting shift status');
      log('📅 Today: $todayKey | Last update: $lastUpdateDate');
      log('⏰ Today shift start: $todayStart');

      // ✅ حفظ اليوم الجديد (باستخدام jobId)
      await prefs.setString('${_lastShiftDateKey}${_currentJobId}', todayKey);

      // ✅ إعادة تعيين الحالة إلى notStarted (بغض النظر عن الوقت)
      _currentStatus = ShiftStatus.notStarted;
      await _saveStatusToPreferences(ShiftStatus.notStarted);

      // ✅ إعادة تعيين arrivalStatus في الـ item نفسه
      log('🔄 Overriding arrivalStatus to not_arrived for new day');
      _currentItem = MyJobItem(
        id: _currentItem.id,
        title: _currentItem.title,
        place: _currentItem.place,
        postedAt: _currentItem.postedAt,
        finalStatus: _currentItem.finalStatus,
        jobStatus: _currentItem.jobStatus,
        job: _currentItem.job,
        applicationStatus: _currentItem.applicationStatus,
        arrivalStatus: 'not_arrived',
        appliedAt: _currentItem.appliedAt,
        applicationId: _currentItem.applicationId,
      );

      // ✅ تحديث الـ UI
      if (state is ShiftLoaded) {
        final currentState = state as ShiftLoaded;
        emit(ShiftLoaded(
          item: _currentItem,
          status: _currentStatus,
          role: currentState.role,
        ));
      }

      log('✅ Shift status reset to notStarted for new day');
    } else {
      log('📅 No reset needed - same day or shift ended');
    }
  }

  Future<void> _saveStatusToPreferences(ShiftStatus status) async {
    if (_currentAppId.isEmpty) {
      log('⚠️ Cannot save status: _currentAppId is empty');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_shiftStatusKey}${_currentAppId}_status', status.name);
    log('💾 Saved status to preferences: ${status.name} for appId: $_currentAppId');
  }

  Future<ShiftStatus> _loadStatusFromPreferences() async {
    if (_currentAppId.isEmpty) {
      log('⚠️ Cannot load status: _currentAppId is empty');
      return ShiftStatus.notStarted;
    }
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('${_shiftStatusKey}${_currentAppId}_status');
    if (saved == null) return ShiftStatus.notStarted;

    final status = ShiftStatus.values.firstWhere(
          (s) => s.name == saved,
      orElse: () => ShiftStatus.notStarted,
    );
    log('📂 Loaded from preferences: $status');
    return status;
  }

  void _updateStatus(ShiftStatus newStatus) {
    _currentStatus = newStatus;
    _saveStatusToPreferences(newStatus);

    if (state is ShiftLoaded) {
      final currentState = state as ShiftLoaded;
      emit(ShiftLoaded(
        item: currentState.item,
        status: newStatus,
        role: currentState.role,
      ));
    }
    log('✅ Status updated: $newStatus');
  }

  void workerOnTheWay() async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    log('🔘 workerOnTheWay | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.notStarted) {
      // ✅ 1. API: shift on-the-way (PATCH)
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.patch(
            '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/on-the-way',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ On the way saved in DB (PATCH /shifts/on-the-way)');
        } catch (e) {
          log('❌ On the way API failed: $e');
        }
      }

      // ✅ 2. Socket للإشعار
      _socketService.workerOnTheWay(_currentAppId, workerId);

      // ✅ 3. تحديث الحالة محلياً
      _updateStatus(ShiftStatus.onTheWay);
    }
  }

  void workerArrived() async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    log('🔘 workerArrived | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.onTheWay) {
      // ✅ 1. API: mark-arrival (POST)
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.post(
            '${ApiConstants.apiBaseUrl}applications/mark-arrival/$_currentAppId',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ Arrival marked in DB (POST /applications/mark-arrival)');
        } catch (e) {
          log('❌ Mark arrival API failed: $e');
        }
      }

      // ✅ 2. API: shift arrive (PATCH)
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.patch(
            '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/arrive',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ Arrive saved in DB (PATCH /shifts/arrive)');
        } catch (e) {
          log('❌ Arrive PATCH API failed: $e');
        }
      }

      // ✅ 3. Socket event للإشعار
      _socketService.workerArrived(_currentAppId, workerId);

      // ✅ 4. تحديث الحالة محلياً
      _updateStatus(ShiftStatus.arrived);
    }
  }

  void approveArrival() async {
    log('🔘 approveArrival | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.arrived) {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

      // ✅ 1. API: approve-arrival (PATCH)
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.patch(
            '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/approve-arrival',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ Arrival approved in DB via API (PATCH /shifts/approve-arrival)');
        } catch (e) {
          log('❌ Approve arrival API failed: $e');
        }
      }

      // ✅ 2. Socket للإشعار
      _socketService.approveArrival(_currentAppId);

      // ✅ 3. تحديث الحالة محلياً
      _updateStatus(ShiftStatus.arrivedApproved);
    }
  }

  void startShift() async {
    log('🔘 startShift | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.arrivedApproved) {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

      // ✅ 1. API لبدء الشيفت
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.patch(
            '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/start',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ Shift started in DB via API (PATCH /shifts/start)');
        } catch (e) {
          log('❌ Start shift API failed: $e');
        }
      }

      // ✅ 2. Socket للإشعار
      _socketService.startShift(_currentAppId);

      // ✅ 3. تحديث الحالة محلياً
      _updateStatus(ShiftStatus.inProgress);
    }
  }

  void endShift() async {
    log('🔘 endShift | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.inProgress) {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

      // ✅ 1. API لإنهاء الشيفت
      if (_currentAppId.isNotEmpty) {
        try {
          final dio = getIt<Dio>();
          await dio.patch(
            '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/end',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );
          log('✅ Shift ended in DB via API (PATCH /shifts/end)');
        } catch (e) {
          log('❌ End shift API failed: $e');
        }
      }

      // ✅ 2. Socket للإشعار
      _socketService.endShift(_currentAppId);

      // ✅ 3. تحديث الحالة محلياً
      _updateStatus(ShiftStatus.completed);
    }
  }

  // ✅ دالة الاستماع للأحداث
  void _listenToSocketEvents() {
    // ✅ استماع لجميع الأحداث (للـ Debug)
    _socketService.onAny((event, data) {
      log('📨 ANY EVENT RECEIVED: $event | data: $data');
    });

    // ===================== Worker Events =====================
    _socketService.on('worker_on_the_way', (data) {
      log('📡 Event: worker_on_the_way received');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.onTheWay);
    });

    _socketService.on('worker_arrived', (data) {
      log('📡 Event: worker_arrived received');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.arrived);
    });

    // ===================== Employer Events =====================
    _socketService.on('arrival_approved', (data) {
      log('📡 Event: arrival_approved received');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.arrivedApproved);
    });

    _socketService.on('shift_started', (data) {
      log('📡🔥 shift_started RECEIVED!');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.inProgress);
    });

    _socketService.on('shift_completed', (data) {
      log('📡 Event: shift_completed received');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.completed);
    });
  }

  @override
  Future<void> close() {
    _socketService.off('worker_on_the_way');
    _socketService.off('worker_arrived');
    _socketService.off('arrival_approved');
    _socketService.off('shift_started');
    _socketService.off('shift_completed');
    _socketService.leaveJobRoom(_currentJobId);
    return super.close();
  }
}