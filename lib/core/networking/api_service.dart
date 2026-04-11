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
import 'package:sheftaya/features/setting/change_password/data/models/change_password_request_body.dart';
import 'package:sheftaya/features/setting/change_password/data/models/change_password_response.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_image_profile_response.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_request_body.dart';
import 'package:sheftaya/features/setting/my_profile/data/models/update_profile_response.dart';
import 'package:sheftaya/features/setting/support_contact/data/models/support_response.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/sign_up/sign_up_response.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_request_body.dart';
import 'package:sheftaya/features/sign_up/data/models/verify_sign_up/verify_signup_response.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';
import 'package:sheftaya/features/worker/home/data/models/apply_for_job/apply_job_response.dart';
import 'package:sheftaya/features/worker/home/data/models/job_recommendation/job_recommendation_response.dart' hide WorkerJobDetailsResponse;
import '../../features/publish_job/data/model/job_details_response.dart';
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
  Future<EmployerJobDetailsResponse> getJobDetails(
    @Header("Authorization") String token,
    @Path("jobId") String jobId,
  );

  @PUT("${ApiConstants.publishJob}/{jobId}")
  Future<PublishJobResponse> updateJob(
    @Header("Authorization") String token,
    @Path("jobId") String jobId,
    @Body() Map<String, dynamic> job,
  );

  @GET(ApiConstants.getOpenJobs)
  Future<JobsResponse> getOpenJobs({
    @Header('Authorization') String? token,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET(ApiConstants.getJobDetails)
  Future<WorkerJobDetailsResponse> getJobDetails2({
    @Path('jobId') required String jobId,
    @Header('Authorization') required String token,
  });
  @GET(ApiConstants.getRecommendations)
  Future<JobRecommendationResponse> getRecommendations(
    @Header('Authorization') String token,
  );
  @POST(ApiConstants.applyForJob)
  Future<ApplyJobResponse> applyForJob(
    @Path('jobId') String jobId,
    @Header('Authorization') String token,
  );

    @MultiPart()
  @PATCH(ApiConstants.updateImageProfile)
  Future<UpdateImageProfileResponse> updateImageProfile(
    @Part(name: 'imageProfile') MultipartFile imageProfile,
    @Header('Authorization') String token,
  );

  @PATCH(ApiConstants.updateProfile)
  Future<UpdateProfileResponse> updateProfile(
    @Body() UpdateProfileRequestBody body,
    @Header('Authorization') String token,
  );
  @MultiPart()
  @POST(ApiConstants.createSupportRequest)
  Future<SupportResponse> createSupportRequest(
    @Part(name: 'problemType') String problemType,
    @Part(name: 'message') String message,
    @Part(name: 'image') MultipartFile? image,
    @Header('Authorization') String token,
  );
  @PUT(ApiConstants.changePassword)
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequestBody body,
    @Header('Authorization') String token,
  );
  // @POST(ApiConstants.updateFcmToken)
  // Future<UpdateFcmResponse> updateFcmToken(
  //   @Header('Authorization') String token,
  //   @Body() UpdateFcmTokenRequestBody updateFcmTokenRequestBody,
  // );
  // @GET(ApiConstants.getAllNotifications)
  // Future<GetAllNotificationsResponse> getAllNotifications(
  //   @Header('Authorization') String token,
  // );

  // @DELETE(ApiConstants.deleteNotification)
  // Future<DeleteNotificationResponse> deleteNotification(
  //   @Header('Authorization') String token,
  //   @Path("id") String id,
  // );

  // @DELETE(ApiConstants.deleteAllNotifications)
  // Future<DeleteAllNotificationsResponse> deleteAllNotifications(
  //   @Header('Authorization') String token,
  // );
}
