import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../models/verify_password_model/verify_password_request_body.dart';
import '../models/verify_password_model/verify_password_response.dart';

class VerifyPasswordRepo {
  final ApiService _apiService;

  VerifyPasswordRepo(this._apiService);

  Future<ServerResult<VerifyPasswordResponse>> verifyForgotPasswordCode(
    VerifyPasswordRequestBody verifyPasswordRequestBody,
  ) async {
    try {
      final response = await _apiService.verifyPassword(
        verifyPasswordRequestBody,
      );
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
