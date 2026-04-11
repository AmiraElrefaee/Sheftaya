import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_image_profile_state.freezed.dart';

@freezed
class UpdateImageProfileState<T> with _$UpdateImageProfileState<T> {
  const factory UpdateImageProfileState.initial() = _Initial;
  const factory UpdateImageProfileState.loading() = _Loading;
  const factory UpdateImageProfileState.success(T data) = _Success<T>;
  const factory UpdateImageProfileState.error({required String error}) = _Error;
}