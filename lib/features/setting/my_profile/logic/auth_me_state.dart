import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/auth_me_response.dart';

part 'auth_me_state.freezed.dart';

@freezed
class AuthMeState with _$AuthMeState {
  const factory AuthMeState.initial() = _Initial;
  const factory AuthMeState.loading() = _Loading;
  const factory AuthMeState.success(AuthMeResponse data) = _Success;
  const factory AuthMeState.error({required String message}) = _Error;
}