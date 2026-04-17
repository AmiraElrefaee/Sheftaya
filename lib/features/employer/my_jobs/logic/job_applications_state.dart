import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/features/employer/my_jobs/data/models/job_applications_response.dart';

part 'job_applications_state.freezed.dart';

@freezed
class JobApplicationsState with _$JobApplicationsState {
  const factory JobApplicationsState.initial() = Initial;

  const factory JobApplicationsState.loading() = Loading;

  const factory JobApplicationsState.loadingMore({
    required JobApplicationsResponse previous,
    required int nextPage,
  }) = LoadingMore;

  const factory JobApplicationsState.accepting({
    required JobApplicationsResponse previous,
  }) = Accepting;

  const factory JobApplicationsState.success({
    required JobApplicationsResponse data,
    required int page,
    required int limit,
    String? status,
    required bool hasNextPage,
  }) = Success;

  const factory JobApplicationsState.error({
    required String message,
  }) = Error;
}