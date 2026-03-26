part of 'job_publish_cubit.dart';

@immutable
sealed class JobPublishState {}

final class JobPublishInitial extends JobPublishState {}
final class PublishJobLoading extends JobPublishState {}
final class PublishJobError extends JobPublishState {
  final String errorMes;

  PublishJobError(this.errorMes);

}
class PublishJobSuccess extends JobPublishState {
  // final PublishJobResponse response;
  final String jobId;

  PublishJobSuccess({required this.jobId});
}