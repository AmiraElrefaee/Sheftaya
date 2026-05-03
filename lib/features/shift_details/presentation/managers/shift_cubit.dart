// features/shift_details/presentation/managers/shift_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/services/socket_service.dart';
import '../../data/model/shift_model.dart';
import '../widget/enums.dart';
import 'dart:developer';
part 'shift_state.dart';


class ShiftCubit extends Cubit<ShiftState> {
  final SocketService _socketService;

  ShiftCubit(this._socketService) : super(ShiftLoading());

  late ShiftModel _currentShift;
  late String _currentJobId;

  void initShiftDetails(String jobId) {
    _currentJobId = jobId;
    log('🚀 initShiftDetails: jobId=$jobId');

    final dummyApiData = {
      'id': jobId,
      'title': 'نادل',
      'companyName': 'Center Perk Cafe',
      'price': 400.0,
      'imageUrl': 'https://link-to-photo.com',
      'startTime': DateTime.now().copyWith(hour: 14, minute: 0),
    };

    _currentShift = ShiftModel.fromApi(dummyApiData);
    log('📦 Initial status: ${_currentShift.status}');
    emit(ShiftLoaded(_currentShift));

    _socketService.joinJobRoom(jobId);
    log('🏠 Joined room: $jobId');

    _listenToSocketEvents();
    log('👂 Listening to socket events...');
  }

  void _listenToSocketEvents() {
    _socketService.on('worker_on_the_way', (_) {
      log('📡 Event received: worker_on_the_way');
      _updateStatus(ShiftStatus.onTheWay);
    });

    _socketService.on('worker_arrived', (_) {
      log('📡 Event received: worker_arrived');
      _updateStatus(ShiftStatus.arrived);
    });

    _socketService.on('arrival_approved', (_) {
      log('📡 Event received: arrival_approved');
      _updateStatus(ShiftStatus.arrivedApproved);
    });

    _socketService.on('shift_started', (_) {
      log('📡 Event received: shift_started');
      _updateStatus(ShiftStatus.inProgress);
    });

    _socketService.on('shift_completed', (_) {
      log('📡 Event received: shift_completed');
      _updateStatus(ShiftStatus.completed);
    });
  }

  void _updateStatus(ShiftStatus newStatus) {
    log('🔄 Updating status: ${_currentShift.status} → $newStatus');
    _currentShift = _currentShift.copyWith(status: newStatus);
    emit(ShiftLoaded(_currentShift));
    log('✅ Status updated & emitted: $newStatus');
  }

  void workerOnTheWay(String appId) async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    log('🔘 workerOnTheWay pressed | current status: ${_currentShift.status}');
    if (_currentShift.status == ShiftStatus.notStarted) {
      log('📤 Emitting worker_on_the_way to socket');
      _socketService.workerOnTheWay(appId, workerId);
    } else {
      log('⛔ workerOnTheWay blocked — status is not notStarted');
    }
  }

  void workerArrived(String appId)async {
    final workerId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
    log('🔘 workerArrived pressed | current status: ${_currentShift.status}');
    if (_currentShift.status == ShiftStatus.onTheWay) {
      log('📤 Emitting worker_arrived to socket');
      _socketService.workerArrived(appId, workerId);
    } else {
      log('⛔ workerArrived blocked — status is not onTheWay');
    }
  }

  void approveArrival(String appId) {
    log('🔘 approveArrival pressed | current status: ${_currentShift.status}');
    if (_currentShift.status == ShiftStatus.arrived) {
      log('📤 Emitting arrival_approved to socket');
      _socketService.approveArrival(appId);
    } else {
      log('⛔ approveArrival blocked — status is not arrived');
    }
  }

  void startShift(String appId) {
    log('🔘 startShift pressed | current status: ${_currentShift.status}');
    if (_currentShift.status == ShiftStatus.arrivedApproved) {
      log('📤 Emitting shift_started to socket');
      _socketService.startShift(appId);
    } else {
      log('⛔ startShift blocked — status is not arrivedApproved');
    }
  }

  void endShift(String appId) {
    log('🔘 endShift pressed | current status: ${_currentShift.status}');
    if (_currentShift.status == ShiftStatus.inProgress) {
      log('📤 Emitting shift_completed to socket');
      _socketService.endShift(appId);
    } else {
      log('⛔ endShift blocked — status is not inProgress');
    }
  }

  @override
  Future<void> close() {
    log('🔚 ShiftCubit closing — leaving room: $_currentJobId');
    _socketService.off('worker_on_the_way');
    _socketService.off('worker_arrived');
    _socketService.off('arrival_approved');
    _socketService.off('shift_started');
    _socketService.off('shift_completed');
    _socketService.leaveJobRoom(_currentJobId);
    return super.close();
  }
}