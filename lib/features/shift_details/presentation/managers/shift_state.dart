part of 'shift_cubit.dart';

@immutable
sealed class ShiftState {}

final class ShiftInitial extends ShiftState {}
class ShiftLoading extends ShiftState {}
class ShiftLoaded extends ShiftState {
  final ShiftModel shift;
  ShiftLoaded(this.shift);
}
class ShiftError extends ShiftState {
  final String message;
  ShiftError(this.message);
}