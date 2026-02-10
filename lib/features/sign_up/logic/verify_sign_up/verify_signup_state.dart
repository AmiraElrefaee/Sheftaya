import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_signup_state.freezed.dart';

@freezed
class VerifySignupState<T> with _$VerifySignupState<T> {
  const factory VerifySignupState.initial() = _Initial;
  const factory VerifySignupState.loading() = Loading;
  const factory VerifySignupState.success(T data) = Success<T>;
  const factory VerifySignupState.error({required String error}) = Error;
}
