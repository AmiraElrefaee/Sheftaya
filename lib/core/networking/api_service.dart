
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sheftaya/core/networking/api_constants.dart';
import 'package:sheftaya/features/forget_password/data/models/create_new_password_model/create_new_password_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/forget_password_model/forget_pass_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/forget_password_model/forget_pass_response.dart';
import 'package:sheftaya/features/forget_password/data/models/verify_password_model/verify_password_request_body.dart';
import 'package:sheftaya/features/forget_password/data/models/verify_password_model/verify_password_response.dart';
import 'package:sheftaya/features/login/data/models/login_request_body.dart';
import 'package:sheftaya/features/login/data/models/login_response.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  // @POST(ApiConstants.signUp)
  // Future<SignupResponse> signup(@Body() SignupRequestBody signupRequestBody);
  // @POST(ApiConstants.verifyAccount)
  // Future<VerifyAccountResponse> verifyAccount(
  //   @Body() VerifyAccountRequestBody verifyAccountRequestBody,
  //   @Header('Authorization') String token,
  // );
  @POST(ApiConstants.forgetPassword)
  Future<ForgetPassResponse> forgetPassword(
    @Body() ForgetPassRequestBody forgetPassRequestBody,
  );

  @POST(ApiConstants.verifyPassword)
  Future<VerifyPasswordResponse> verifyPassword(
    @Body() VerifyPasswordRequestBody verifyPasswordRequestBody,
  );
  @POST(ApiConstants.resetPassword)
  Future<void> createNewPassword(
    @Body() CreateNewPasswordRequestBody createNewPasswordRequestBody,
  );
}
