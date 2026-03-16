import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sheftaya/core/constants/app_constants.dart';

class DioFactory {
  DioFactory._();
  static Dio? dio;

  static Dio getDio() {
    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = AppConstants.connectionTimeout
        ..options.receiveTimeout = AppConstants.receiveTimeout;
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
        logPrint: (object) {
          print('🛰️ $object');
        },
      ),
    );
    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("📤 REQUEST → ${options.method} ${options.baseUrl}${options.path}");
          print("📦 DATA → ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("📥 RESPONSE → ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("❌ ERROR → ${error.response?.data}");
          return handler.next(error);
        },

      ),
    );
  }

  static void setTokenIntoHeaderAfterSignUp(String token) {
    dio?.options.headers = {'Authorization': 'Bearer $token'};
  }
}
