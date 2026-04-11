import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState<T> with _$ChangePasswordState<T> {
  const factory ChangePasswordState.initial() = _Initial;
  const factory ChangePasswordState.loading() = _Loading;
  const factory ChangePasswordState.success(T data) = _Success<T>;
  const factory ChangePasswordState.error({required String error}) = _Error;
}