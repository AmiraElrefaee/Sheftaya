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
    log('🔧 _currentRole set to: $_currentRole');

    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    final userId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId); // ✅ تعريف واحد فقط هنا

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

    // ✅ استخدام userId المعرف أعلاه (ليس تعريف جديد)
    _socketService.joinJobRoom(_currentJobId);
    if (userId.isNotEmpty) {
      _socketService.joinUserRoom(userId);
      log('👤 Worker joined user room: $userId');
    }

    _listenToSocketEvents();
  }

  Future<void> _saveStatusToPreferences(ShiftStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_shiftStatusKey}${_currentAppId}_status', status.name);
    log('💾 Saved status to preferences: ${status.name}');
  }

  Future<ShiftStatus> _loadStatusFromPreferences() async {
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

  // ✅ دالة الاستماع للأحداث (أضيفيها هنا)
  void _listenToSocketEvents() {
    _socketService.onAny((event, data) {
      log('📨 ANY EVENT: $event | $data');
    });

    // استماع للأحداث القادمة للـ user room
    _socketService.on('shift_started', (data) {
      log('📡 Event: shift_started received by worker');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.inProgress);
    });

    _socketService.on('shift_completed', (data) {
      log('📡 Event: shift_completed received by worker');
      log('📡 Data: $data');
      _updateStatus(ShiftStatus.completed);
    });

    // أحداث arrival
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
    log('✅ Status updated and saved: $newStatus');
  }

  void workerOnTheWay() async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    log('🔘 workerOnTheWay | status: $_currentStatus');
    if (_currentStatus == ShiftStatus.notStarted) {
      _socketService.workerOnTheWay(_currentAppId, workerId);
      _updateStatus(ShiftStatus.onTheWay);
    }
  }

  void workerArrived() async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    log('🔘 workerArrived | status: $_currentStatus | appId: $_currentAppId');

    if (_currentStatus == ShiftStatus.onTheWay) {
      try {
        final dio = getIt<Dio>();
        await dio.post(
          '${ApiConstants.apiBaseUrl}applications/mark-arrival/$_currentAppId',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        log('✅ Arrival marked in DB');
      } catch (e) {
        log('❌ Mark arrival failed: $e');
      }
      _socketService.workerArrived(_currentAppId, workerId);
      _updateStatus(ShiftStatus.arrived);
    }
  }

  void approveArrival() {
    log('🔘 approveArrival | status: $_currentStatus');
    if (_currentStatus == ShiftStatus.arrived) {
      _socketService.approveArrival(_currentAppId);
      _updateStatus(ShiftStatus.arrivedApproved);
    }
  }

  void startShift() async {
    log('🔘 startShift | status: $_currentStatus');
    if (_currentStatus == ShiftStatus.arrivedApproved) {
      // ✅ أولاً: بعث الحدث للسيرفر
      _socketService.startShift(_currentAppId);
      log('📤 shift_started emitted to server');

      // ✅ ثانياً: استدعاء API
      await _callShiftEndpoint('start');

      // ✅ ثالثاً: تحديث الحالة محلياً
      _updateStatus(ShiftStatus.inProgress);
    }
  }
  void endShift() {
    log('🔘 endShift | status: $_currentStatus');
    if (_currentStatus == ShiftStatus.inProgress) {
      _callShiftEndpoint('end');
      _updateStatus(ShiftStatus.completed);
    }
  }

  Future<void> _callShiftEndpoint(String action) async {
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    try {
      final dio = getIt<Dio>();
      await dio.patch(
        '${ApiConstants.apiBaseUrl}shifts/$_currentAppId/$action',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      log('✅ Shift $action called successfully');
    } catch (e) {
      log('❌ Failed to call shift $action: $e');
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