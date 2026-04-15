import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

part 'my_jobs_state.freezed.dart';

@freezed
class MyJobsState with _$MyJobsState {
  const factory MyJobsState.initial() = _Initial;
  const factory MyJobsState.loading() = _Loading;
  const factory MyJobsState.success(MyJobsResponse data) = _Success;
  const factory MyJobsState.error({required String message}) = _Error;
}