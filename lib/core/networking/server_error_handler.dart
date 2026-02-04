import 'package:dio/dio.dart';

abstract class Failure {
  final String errmessage;

  Failure({required this.errmessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errmessage});
  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errmessage: 'انتهت مهلة الاتصال');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errmessage: 'فشل في إرسال الطلب');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errmessage: 'فشل في استلام الرد');
      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          final serverMessage = responseData['message'] as String?;
          if (serverMessage != null && serverMessage.isNotEmpty) {
            return ServerFailure(errmessage: serverMessage);
          }
        }
        return ServerFailure.fromResponse(
          e.response!.statusCode!,
          e.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(errmessage: 'تم إلغاء الطلب');
      case DioExceptionType.unknown:
        if (e.message!.contains('SocketException')) {
          return ServerFailure(errmessage: 'لا يوجد اتصال بالإنترنت');
        } else {
          return ServerFailure(
            errmessage: 'حدث خطأ غير معروف، برجاء المحاولة مرة أخرى',
          );
        }
      default:
        return ServerFailure(errmessage: 'لا يوجد اتصال بالإنترنت');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (response == null) {
      return ServerFailure(errmessage: 'حدث خطأ، برجاء المحاولة مرة أخرى');
    }

    if (response is Map<String, dynamic>) {
      if (response['errors'] != null && response['errors'] is List) {
        final errors = response['errors'] as List;
        if (errors.isNotEmpty && errors[0] is Map<String, dynamic>) {
          final firstError = errors[0] as Map<String, dynamic>;
          if (firstError['msg'] != null) {
            return ServerFailure(errmessage: firstError['msg'] as String);
          }
        }
      }
      if (response['message'] != null) {
        return ServerFailure(errmessage: response['message']);
      }
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errmessage: 'بيانات غير صحيحة');
    } else if (statusCode == 404) {
      return ServerFailure(errmessage: 'لم يتم العثور على البيانات المطلوبة');
    } else if (statusCode == 500) {
      return ServerFailure(
        errmessage: 'حدث خطأ في الخادم، برجاء المحاولة مرة أخرى',
      );
    } else {
      return ServerFailure(errmessage: 'حدث خطأ، برجاء المحاولة مرة أخرى');
    }
  }
}

class ServerErrorHandler implements Exception {
  late ServerFailure serverFailure;

  ServerErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      serverFailure = _handleError(error);
    } else {
      serverFailure = ServerFailure(errmessage: 'حدث خطأ غير متوقع');
    }
  }

  ServerFailure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(errmessage: 'انتهت مهلة الاتصال بالخادم');
      case DioExceptionType.sendTimeout:
        return ServerFailure(errmessage: 'انتهت مهلة إرسال الطلب');
      case DioExceptionType.receiveTimeout:
        return ServerFailure(errmessage: 'انتهت مهلة استلام البيانات');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          error.response!.statusCode!,
          error.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(errmessage: 'تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return ServerFailure(errmessage: 'لا يوجد اتصال بالإنترنت');
      default:
        return ServerFailure(errmessage: 'حدث خطأ غير معروف');
    }
  }
}

