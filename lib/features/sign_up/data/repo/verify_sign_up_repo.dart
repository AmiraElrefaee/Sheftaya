import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_response.dart';

class VerifySignupRepo {
  final ApiService _apiService;

  VerifySignupRepo(this._apiService);

  Future<ServerResult<VerifySignupResponse>> verify(
    VerifySignupRequestBody body,
  ) async {
    try {
      final response = await _apiService.verifySignup(body);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
