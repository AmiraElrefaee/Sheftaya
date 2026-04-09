import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/apply_for_job/apply_job_response.dart';

class ApplyJobRepo {
  final ApiService _apiService;

  ApplyJobRepo(this._apiService);

  Future<ServerResult<ApplyJobResponse>> applyForJob(
    String jobId,
    String token,
  ) async {
    try {
      final response = await _apiService.applyForJob(jobId, token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}