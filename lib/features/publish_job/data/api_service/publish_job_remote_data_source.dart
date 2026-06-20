import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/dio_factory.dart';
import '../../../../core/networking/server_error_handler.dart';
import '../model/publish_job.dart';
import '../model/publish_job_request.dart';

class JobRemoteDataSource {
  final ApiService _apiService =
  ApiService(DioFactory.getDio(), baseUrl: ApiConstants.apiBaseUrl);

  Future<PublishJobResponse> publishJob(JobModel job) async {
    try {
      final String token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );
      final String formattedToken =
      token.startsWith('Bearer') ? token : 'Bearer $token';

      final response = await _apiService.publishJob(
        formattedToken,
        job.toJson(),
      );
      return response;
    } catch (e) {
      throw ServerErrorHandler.handle(e).serverFailure;
    }
  }

  // ✅ للتحديث - تستقبل Map
  Future<PublishJobResponse> updateJob(
      String jobId,
      Map<String, dynamic> jobData,
      ) async {
    try {
      final String token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );
      final String formattedToken =
      token.startsWith('Bearer') ? token : 'Bearer $token';

      final response = await _apiService.updateJob(
        formattedToken,
        jobId,
        jobData, // ✅ Map مباشرة
      );
      return response;
    } catch (e) {
      throw ServerErrorHandler.handle(e).serverFailure;
    }
  }
}