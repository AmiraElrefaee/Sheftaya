
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../models/forget_password_model/forget_pass_request_body.dart';
import '../models/forget_password_model/forget_pass_response.dart';

class ForgetPassRepo {
  final ApiService _apiService;

  ForgetPassRepo(this._apiService);

  Future<ServerResult<ForgetPassResponse>> forgetPassword(
    ForgetPassRequestBody forgetPassRequestBody,
  ) async {
    try {
      final response = await _apiService.forgetPassword(forgetPassRequestBody);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
