import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import '../models/create_new_password_model/create_new_password_request_body.dart';
import '../models/create_new_password_model/create_new_password_response.dart';

class CreateNewPasswordRepo {
  final ApiService _apiService;

  CreateNewPasswordRepo(this._apiService);

  Future<ServerResult<CreateNewPasswordResponse>> createNewPassword(
    String resetToken,
    CreateNewPasswordRequestBody body,
  ) async {
    try {
      final response = await _apiService.createNewPassword(
        "Bearer $resetToken",
        body,
      );
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
