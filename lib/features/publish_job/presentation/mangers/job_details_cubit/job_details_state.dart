part of 'job_details_cubit.dart';

@immutable
sealed class JobDetailsState {}

final class JobDetailsInitial extends JobDetailsState {}
class JobDetailsLoading extends JobDetailsState {}

class JobDetailsSuccess extends JobDetailsState {
  final JobDetails job;

  JobDetailsSuccess(this.job);
}

class JobDetailsError extends JobDetailsState {
  final String message;

  JobDetailsError(this.message);
}