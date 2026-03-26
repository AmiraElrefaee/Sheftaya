import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/open_jobs_response.dart';

part 'open_jobs_state.freezed.dart';

@freezed
class OpenJobsState with _$OpenJobsState {
  const factory OpenJobsState.initial() = _Initial;
  const factory OpenJobsState.loading() = _Loading;
  const factory OpenJobsState.success(OpenJobsResponse data) = _Success;
  const factory OpenJobsState.error({required String message}) = _Error;
}