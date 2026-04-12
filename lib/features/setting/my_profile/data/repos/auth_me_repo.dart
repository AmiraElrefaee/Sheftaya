import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/auth_me_response.dart';

class AuthMeRepo {
  final ApiService _apiService;

  AuthMeRepo(this._apiService);

  Future<ServerResult<AuthMeResponse>> getMe(String token) async {
    try {
      final response = await _apiService.getMe(token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}