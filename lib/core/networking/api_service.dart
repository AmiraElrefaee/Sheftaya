import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sheftaya/core/networking/api_constants.dart';
import 'package:sheftaya/features/forget_password/data/models/create_new_password_model/create_new_password_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/create_new_password_model/create_new_password_response.dart';
import 'package:sheftaya/features/forget_password/data/models/forget_password_model/forget_pass_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/forget_password_model/forget_pass_response.dart';
import 'package:sheftaya/features/forget_password/data/models/verify_password_model/verify_password_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/verify_password_model/verify_password_response.dart';
import 'package:sheftaya/features/login/data/models/login_request_body.dart';
import 'package:sheftaya/features/login/data/models/login_response.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_response.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_response.dart';

import '../../features/publish_job/data/model/job_details_response.dart';
import '../../features/publish_job/data/model/publish_job.dart';
import '../../features/publish_job/data/model/publish_job_request.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {

  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.signUp)
  Future<SignupResponse> signup(
    @Header("Authorization") String token,
    @Body() SignupRequestBody signupRequestBody,
  );

  @POST(ApiConstants.verifyAccount)
  Future<VerifySignupResponse> verifySignup(
    @Body() VerifySignupRequestBody body,
  );

  @POST(ApiConstants.forgetPassword)
  Future<ForgetPassResponse> forgetPassword(
    @Body() ForgetPassRequestBody forgetPassRequestBody,
  );

  @POST(ApiConstants.verifyPassword)
  Future<VerifyPasswordResponse> verifyPassword(
    @Body() VerifyPasswordRequestBody verifyPasswordRequestBody,
  );
  @POST(ApiConstants.resetPassword)
  Future<CreateNewPasswordResponse> createNewPassword(
    @Header("Authorization") String token,
    @Body() CreateNewPasswordRequestBody body,
  );

  @POST(ApiConstants.publishJob)
  Future<PublishJobResponse> publishJob(
      @Header("Authorization") String token,
      @Body() Map<String, dynamic> job,
      );
  @GET(ApiConstants.getJobDetails)
  Future<JobDetailsResponse> getJobDetails(
      @Header("Authorization") String token,
      @Path("jobId") String jobId,
      );
  // inside ApiService
  @PUT("${ApiConstants.publishJob}/{jobId}") // سيصبح base_url/jobs/job_id
  Future<PublishJobResponse> updateJob(
      @Header("Authorization") String token,
      @Path("jobId") String jobId,
      @Body() Map<String, dynamic> job,
      );
}
