import 'package:dartz/dartz.dart';
import '../../../../core/networking/server_error_handler.dart';
import '../../data/api_service/publish_job_remote_data_source.dart';
import '../../data/model/publish_job.dart';
import '../../data/model/publish_job_request.dart';

class JobRepository {
  final JobRemoteDataSource _remoteDataSource;

  JobRepository(this._remoteDataSource);

  Future<Either<Failure, PublishJobResponse>> publishJob(JobModel job) async {
    try {
      final response = await _remoteDataSource.publishJob(job);
      return Right(response);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
  // inside JobRepository
  Future<Either<Failure, PublishJobResponse>> updateJob(String jobId, JobModel job) async {
    try {
      final response = await _remoteDataSource.updateJob(jobId, job);
      return Right(response);
    } catch (e) {
      return Left(ServerErrorHandler.handle(e).serverFailure);
    }
  }
}