import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/open_jobs_response.dart';

class OpenJobsRepo {
  final ApiService _apiService;

  OpenJobsRepo(this._apiService);

  Future<ServerResult<OpenJobsResponse>> getOpenJobs({
    required String token,
  }) async {
    try {
      final response = await _apiService.getOpenJobs(token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}