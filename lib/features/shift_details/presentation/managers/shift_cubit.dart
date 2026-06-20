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

    // ✅ إذا كان Employer و _currentAppId فاضي، جيبها من الـ API
    if (_currentRole == 'employer' && _currentAppId.isEmpty) {
      _currentAppId = await _fetchApplicationIdForJob();
      log('🔧 _currentAppId (after fetch): $_currentAppId');
    }

    log('🔧 =========================================');

    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    final userId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);

    _currentStatus = await _loadStatusFromPreferences();
    log('📊 Loaded from preferences: $_currentStatus');

    if (_currentStatus == ShiftStatus.notStarted) {
      _currentStatus = await _fetchStatusFromApi(token);
      log('📊 Fetched from API: $_currentStatus');
      await _saveStatusToPreferences(_currentStatus);
    }

    emit(ShiftLoaded(
      item: item,
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

  // ✅ جلب applicationId للـ Employer من API
  Future<String> _fetchApplicationIdForJob() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      final dio = getIt<Dio>();

      log('📡 Fetching applicationId for jobId: $_currentJobId');

      final response = await dio.get(
        '${ApiConstants.apiBaseUrl}applications/jobs/$_currentJobId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      log('📡 Response status: ${response.statusCode}');
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

  Future<ShiftStatus> _fetchStatusFromApi(String token) async {
    try {
      final dio = getIt<Dio>();

      if (_currentRole == 'employer') {
        log('📡 Using employer endpoint');
        final response = await dio.get(
          '${ApiConstants.apiBaseUrl}applications/jobs/$_currentJobId',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        final data = response.data['data'] as List?;
        if (data != null && data.isNotEmpty) {
          for (final app in data) {
            final arrivalStatus = app['arrivalStatus'] as String? ?? 'not_arrived';
            if (arrivalStatus == 'arrived') return ShiftStatus.arrived;
            if (arrivalStatus == 'on_the_way') return ShiftStatus.onTheWay;
          }
        }
      } else {
        log('📡 Using worker endpoint (my-applications)');
        final response = await dio.get(
          '${ApiConstants.apiBaseUrl}applications/my-applications',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        final data = response.data['data'] as List?;
        if (data != null) {
          for (final app in data) {
            final jobIdFromApi = app['job']?['_id'] as String? ?? '';
            final arrivalStatus = app['arrivalStatus'] as String? ?? 'not_arrived';
            if (jobIdFromApi == _currentJobId) {
              if (arrivalStatus == 'arrived') return ShiftStatus.arrived;
              if (arrivalStatus == 'on_the_way') return ShiftStatus.onTheWay;
            }
          }
        }
      }
    } catch (e) {
      log('❌ Failed to fetch status: $e');
    }
    return ShiftStatus.notStarted;
  }

  void _listenToSocketEvents() {
    _socketService.onAny((event, data) {
      log('📨 ANY EVENT: $event | $data');
    });

    _socketService.on('shift_started', (data) {
      log('📡 Event: shift_started received');
      _updateStatus(ShiftStatus.inProgress);
    });

    _socketService.on('shift_completed', (data) {
      log('📡 Event: shift_completed received');
      _updateStatus(ShiftStatus.completed);
    });

    _socketService.on('worker_on_the_way', (_) {
      log('📡 Event: worker_on_the_way');
      _updateStatus(ShiftStatus.onTheWay);
    });

    _socketService.on('worker_arrived', (_) {
      log('📡 Event: worker_arrived');
      _updateStatus(ShiftStatus.arrived);
    });

    _socketService.on('arrival_approved', (_) {
      log('📡 Event: arrival_approved');
      _updateStatus(ShiftStatus.arrivedApproved);
    });
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
      // ✅ 1. API: mark-arrival (POST) - الـ endpoint القديم
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

      // ✅ 2. API: shift arrive (PATCH) - الـ endpoint الجديد
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