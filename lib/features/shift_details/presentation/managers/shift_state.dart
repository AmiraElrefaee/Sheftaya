part of 'shift_cubit.dart';

sealed class ShiftState {}

final class ShiftInitial extends ShiftState {}
class ShiftLoading extends ShiftState {}

class ShiftLoaded extends ShiftState {
  final MyJobItem item;
  final ShiftStatus status;
  final UserRole role;

  ShiftLoaded({
    required this.item,
    required this.status,
    required this.role,
  });

  bool get isWorkerArrived =>
      status == ShiftStatus.arrived ||
          status == ShiftStatus.arrivedApproved ||
          status == ShiftStatus.inProgress ||
          status == ShiftStatus.completed;

  bool get isEmployerConfirmed =>
      status == ShiftStatus.arrivedApproved ||
          status == ShiftStatus.inProgress ||
          status == ShiftStatus.completed;
}

class ShiftError extends ShiftState {
  final String message;
  ShiftError(this.message);
}