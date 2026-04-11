import 'package:freezed_annotation/freezed_annotation.dart';

part 'support_state.freezed.dart';

@freezed
class SupportState<T> with _$SupportState<T> {
  const factory SupportState.initial() = _Initial;
  const factory SupportState.loading() = _Loading;
  const factory SupportState.success(T data) = _Success<T>;
  const factory SupportState.error({required String error}) = _Error;
}