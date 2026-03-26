import '../../../../core/constants/shared_pref_helper.dart';
import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/dio_factory.dart';
import '../model/job_details_response.dart';

class JobDetailsRemoteDataSource {
  final ApiService _apiService =
  ApiService(DioFactory.getDio(), baseUrl: ApiConstants.apiBaseUrl);
  // JobDetailsRemoteDataSource(this._apiService);

  Future<JobDetailsResponse> getJobDetails(String jobId) async {
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    final formattedToken =
    token.startsWith('Bearer') ? token : 'Bearer $token';

    final JobDetailsResponse response = await _apiService.getJobDetails(
      formattedToken,
      jobId,
    );

    return response;
  }
}