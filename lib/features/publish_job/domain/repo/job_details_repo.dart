import '../../data/api_service/job_details_remote_data_source.dart';
import '../../data/model/job_details_response.dart';

class JobDetailsRepo {
  final JobDetailsRemoteDataSource remoteDataSource;

  JobDetailsRepo(this.remoteDataSource);

  Future<JobDetails> getJobDetails(String jobId) async {
    final response = await remoteDataSource.getJobDetails(jobId);

    return response.data.job;
  }
}