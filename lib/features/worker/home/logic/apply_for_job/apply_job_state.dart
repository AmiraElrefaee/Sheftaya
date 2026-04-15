import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/features/worker/home/data/models/apply_for_job/apply_job_response.dart';

part 'apply_job_state.freezed.dart';

@freezed
class ApplyJobState with _$ApplyJobState {
  const factory ApplyJobState.initial() = _Initial;
  const factory ApplyJobState.loading() = _Loading;
  const factory ApplyJobState.success(ApplyJobResponse data) = _Success;
  const factory ApplyJobState.error({required String error}) = _Error;
}