import 'package:dio/dio.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_response.dart';

class SignupRepo {
  final Dio _dio;

  SignupRepo(this._dio);

  Future<ServerResult<SignupResponse>> signup(
    SignupRequestBody signupRequestBody,
  ) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('firstName', signupRequestBody.firstName),
        MapEntry('lastName', signupRequestBody.lastName),
        MapEntry('email', signupRequestBody.email),
        MapEntry('password', signupRequestBody.password),
        MapEntry('confirmPassword', signupRequestBody.confirmPassword),
        MapEntry('role', signupRequestBody.role),
      ]);

      if (signupRequestBody.phone != null) {
        formData.fields.add(MapEntry('phone', signupRequestBody.phone!));
      }
      if (signupRequestBody.preferredLang != null) {
        formData.fields.add(MapEntry('preferredLang', signupRequestBody.preferredLang!));
      }
      if (signupRequestBody.city != null) {
        formData.fields.add(MapEntry('city', signupRequestBody.city!));
      }
      if (signupRequestBody.birthDate != null) {
        formData.fields.add(MapEntry('birthDate', signupRequestBody.birthDate!));
      }

      if (signupRequestBody.frontIdImage != null) {
        formData.files.add(MapEntry(
          'frontIdImage',
          await MultipartFile.fromFile(
            signupRequestBody.frontIdImage!,
            filename: signupRequestBody.frontIdImage!.split('/').last,
          ),
        ));
      }

      if (signupRequestBody.backIdImage != null) {
        formData.files.add(MapEntry(
          'backIdImage',
          await MultipartFile.fromFile(
            signupRequestBody.backIdImage!,
            filename: signupRequestBody.backIdImage!.split('/').last,
          ),
        ));
      }

      if (signupRequestBody.selfieImage != null) {
        formData.files.add(MapEntry(
          'selfieImage',
          await MultipartFile.fromFile(
            signupRequestBody.selfieImage!,
            filename: signupRequestBody.selfieImage!.split('/').last,
          ),
        ));
      }

      if (signupRequestBody.employerProfile != null) {
        final emp = signupRequestBody.employerProfile!;
        formData.fields.addAll([
          MapEntry('employerProfile[companyName]', emp.companyName),
          MapEntry('employerProfile[companyType]', emp.companyType),
          MapEntry('employerProfile[companyAddress]', emp.companyAddress),
          MapEntry('employerProfile[city]', emp.city),
        ]);

        if (emp.companyImages != null && emp.companyImages!.isNotEmpty) {
          for (var image in emp.companyImages!) {
            formData.files.add(MapEntry(
              'companyImages',
              await MultipartFile.fromFile(
                image,
                filename: image.split('/').last,
              ),
            ));
          }
        }
      }

      if (signupRequestBody.workerProfile != null) {
        final worker = signupRequestBody.workerProfile!;
        formData.fields.addAll([
          MapEntry('workerProfile[education]', worker.education),
          MapEntry('workerProfile[professionalStatus]', worker.professionalStatus),
          MapEntry('workerProfile[experienceYears]', worker.experienceYears.toString()),
          MapEntry('workerProfile[expectedHourlyRate][amount]', worker.expectedHourlyRate.amount.toString()),
          MapEntry('workerProfile[expectedHourlyRate][currency]', worker.expectedHourlyRate.currency),
        ]);

        for (var exp in worker.pastExperience) {
          formData.fields.add(MapEntry('workerProfile[pastExperience][]', exp));
        }

        for (var job in worker.jobsLookedFor) {
          formData.fields.add(MapEntry('workerProfile[jobsLookedFor][]', job));
        }

        for (int i = 0; i < worker.availability.length; i++) {
          final avail = worker.availability[i];
          formData.fields.addAll([
            MapEntry('workerProfile[availability][$i][day]', avail.day),
            MapEntry('workerProfile[availability][$i][from]', avail.from),
            MapEntry('workerProfile[availability][$i][to]', avail.to),
          ]);
        }

        if (worker.healthCertificate != null) {
          formData.files.add(MapEntry(
            'healthCertificate',
            await MultipartFile.fromFile(
              worker.healthCertificate!,
              filename: worker.healthCertificate!.split('/').last,
            ),
          ));
        }
      }

      final response = await _dio.post(
        'https://sheftaya.vercel.app/auth/signup',
        data: formData,
      );

      return ServerResult.success(SignupResponse.fromJson(response.data));
    } catch (error) {
      return ServerResult.failure(ServerErrorHandler.handle(error));
    }
  }
}
