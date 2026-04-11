

import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_response.dart';

class UpdateProfileRepo {
  final ApiService _apiService;

  UpdateProfileRepo(this._apiService);

  Future<ServerResult<UpdateProfileResponse>> updateProfile(
    UpdateProfileRequestBody body,
    String token,
  ) async {
    try {
      final response = await _apiService.updateProfile(body, token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}