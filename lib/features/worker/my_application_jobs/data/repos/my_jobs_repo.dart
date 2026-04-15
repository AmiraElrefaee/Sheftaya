import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class MyJobsRepo {
  final ApiService _apiService;

  MyJobsRepo(this._apiService);

  Future<ServerResult<MyJobsResponse>> getMyJobs(String token) async {
    try {
      final response = await _apiService.getMyJobs(token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}