import 'package:freezed_annotation/freezed_annotation.dart';

part 'apply_job_state.freezed.dart';

@freezed
class ApplyJobState<T> with _$ApplyJobState<T> {
  const factory ApplyJobState.initial() = _Initial;
  const factory ApplyJobState.loading() = _Loading;
  const factory ApplyJobState.success(T data) = _Success<T>;
  const factory ApplyJobState.error({required String error}) = _Error;
}