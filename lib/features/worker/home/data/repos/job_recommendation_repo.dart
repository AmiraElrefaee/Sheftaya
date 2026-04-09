
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/job_recommendation/job_recommendation_response.dart';

class JobsRecommendationsRepo {
  final ApiService _apiService;

  JobsRecommendationsRepo(this._apiService);

  Future<ServerResult<JobRecommendationResponse>> getRecommendations(
    String token,
  ) async {
    try {
      final response = await _apiService.getRecommendations(token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}