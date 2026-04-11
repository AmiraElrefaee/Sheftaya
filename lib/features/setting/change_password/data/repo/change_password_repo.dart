

import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/change_password/data/models/change_password_request_body.dart';
import 'package:sheftaya/features/setting/change_password/data/models/change_password_response.dart';

class ChangePasswordRepo {
  final ApiService _apiService;

  ChangePasswordRepo(this._apiService);

  Future<ServerResult<ChangePasswordResponse>> changePassword(
    ChangePasswordRequestBody body,
    String token,
  ) async {
    try {
      final response = await _apiService.changePassword(body, token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
