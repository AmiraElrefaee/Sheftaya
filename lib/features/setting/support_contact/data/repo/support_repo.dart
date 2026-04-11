import 'package:dio/dio.dart';
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/setting/support_contact/data/models/support_request_body.dart';
import 'package:sheftaya/features/setting/support_contact/data/models/support_response.dart';


class SupportRepo {
  final ApiService _apiService;

  SupportRepo(this._apiService);

  Future<ServerResult<SupportResponse>> createSupportRequest(
    SupportRequestBody body,
    String token,
  ) async {
    try {
      MultipartFile? imageFile;
      if (body.imagePath != null && body.imagePath!.isNotEmpty) {
        imageFile = await MultipartFile.fromFile(body.imagePath!);
      }

      final response = await _apiService.createSupportRequest(
        body.problemType,
        body.message,
        imageFile,
        token,
      );

      return ServerResult.success(response);
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}