import 'package:dio/dio.dart';
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_image_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_image_profile_response.dart';


class UpdateImageProfileRepo {
  final ApiService _apiService;

  UpdateImageProfileRepo(this._apiService);

  Future<ServerResult<UpdateImageProfileResponse>> updateImageProfile(
    UpdateImageProfileRequestBody body,
    String token,
  ) async {
    try {
      final file = await MultipartFile.fromFile(body.imagePath);
      final response = await _apiService.updateImageProfile(file, token);
      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}