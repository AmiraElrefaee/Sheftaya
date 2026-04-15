import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/notification/data/models/update_fcm/update_fcm_response.dart';
import 'package:sheftaya/features/notification/data/models/update_fcm/update_fcm_token_request_body.dart';

class UpdateFcmRepo {
  final ApiService _apiService;

  UpdateFcmRepo(this._apiService);

  Future<ServerResult<UpdateFcmResponse>> updateFcm(
    UpdateFcmTokenRequestBody updateFcmTokenRequestBody,
    String token,
  ) async {
    try {
      final response = await _apiService.updateFcmToken(
        token,
        updateFcmTokenRequestBody,
      );
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
