import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/employer/my_jobs/data/models/accept_worker_response.dart';
import 'package:sheftaya/features/employer/my_jobs/data/models/job_applications_response.dart';

class JobApplicationsRepo {
  final ApiService _apiService;

  JobApplicationsRepo(this._apiService);

  Future<ServerResult<JobApplicationsResponse>> getApplicationsForJob(
    String jobId, {
    int page = 1,
    int limit = 20,
    String? status,
    required String token,
  }) async {
    try {
      final response = await _apiService.getApplicationsForJob(
        jobId,
        page,
        limit,
        status,
        token,
      );
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }

  Future<ServerResult<AcceptWorkerResponse>> acceptWorker(
    String jobId,
    String applicationId,
    String token,
  ) async {
    try {
      final response = await _apiService.acceptWorker(
        jobId,
        applicationId,
        token,
      );
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}