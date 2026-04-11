import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/networking/api_constants.dart';
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/dio_factory.dart';
import 'package:sheftaya/features/forget_password/data/repos/create_new_password.dart';
import 'package:sheftaya/features/forget_password/data/repos/forget_pass_repo.dart';
import 'package:sheftaya/features/forget_password/data/repos/verify_password_repo.dart';
import 'package:sheftaya/features/forget_password/logic/create_new_password_cubit/create_new_password_cubit.dart';
import 'package:sheftaya/features/forget_password/logic/forget_password_cubit/forget_password_cubit.dart';
import 'package:sheftaya/features/forget_password/logic/verify_password_cubit/verify_password_cubit.dart';
import 'package:sheftaya/features/login/data/repos/login_repo.dart';
import 'package:sheftaya/features/login/logic/login_cubit.dart';
import 'package:sheftaya/features/setting/change_password/data/repo/change_password_repo.dart';
import 'package:sheftaya/features/setting/change_password/logic/change_password_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/update_image_profile_repo.dart';
import 'package:sheftaya/features/setting/my_profile/data/repos/update_profile_repo.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_image_profile_cubit.dart';
import 'package:sheftaya/features/setting/my_profile/logic/update_profile_cubit.dart';
import 'package:sheftaya/features/setting/support_contact/data/repo/support_repo.dart';
import 'package:sheftaya/features/setting/support_contact/logic/support_cubit.dart';
import 'package:sheftaya/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:sheftaya/features/sign_up/data/repo/verify_sign_up_repo.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';
import 'package:sheftaya/features/worker/home/data/repos/apply_job_repo.dart';
import 'package:sheftaya/features/worker/home/data/repos/job_recommendation_repo.dart';
import 'package:sheftaya/features/worker/home/data/repos/jobs_repo.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/apply_for_job/apply_job_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/job_details/job_details_cubit.dart'
    as worker_cubit;
import 'package:sheftaya/features/worker/home/logic/job_recommendation/job_recommendation_cubit.dart';

import '../../features/publish_job/data/api_service/job_details_remote_data_source.dart';
import '../../features/publish_job/data/api_service/publish_job_remote_data_source.dart';
import '../../features/publish_job/domain/repo/job_details_repo.dart';
import '../../features/publish_job/domain/repo/job_post_repo.dart';
import '../../features/publish_job/presentation/mangers/job_details_cubit/job_details_cubit.dart';
import '../../features/publish_job/presentation/mangers/job_publish_cubit/job_publish_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Dio instance
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());

  // Register ApiService
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt(), baseUrl: ApiConstants.apiBaseUrl),
  );

  // User Cubit
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt(), getIt<UserCubit>()),
  );

  // signup
  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt<Dio>()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));

  // forget password
  getIt.registerLazySingleton<ForgetPassRepo>(() => ForgetPassRepo(getIt()));
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(getIt()),
  );

  // verify password
  getIt.registerLazySingleton<VerifyPasswordRepo>(
    () => VerifyPasswordRepo(getIt()),
  );
  getIt.registerFactoryParam<VerifyPasswordCubit, String, void>(
    (email, _) => VerifyPasswordCubit(getIt(), email),
  );

  // create new password
  getIt.registerLazySingleton<CreateNewPasswordRepo>(
    () => CreateNewPasswordRepo(getIt()),
  );
  getIt.registerFactoryParam<CreateNewPasswordCubit, String, void>(
    (resetToken, _) => CreateNewPasswordCubit(getIt(), resetToken),
  );

  // verify account
  getIt.registerLazySingleton<VerifySignupRepo>(
    () => VerifySignupRepo(getIt()),
  );
  getIt.registerFactory<VerifySignupCubit>(
    () => VerifySignupCubit(getIt(), getIt<UserCubit>()),
  );

  // publish job
  getIt.registerLazySingleton<JobRemoteDataSource>(() => JobRemoteDataSource());
  getIt.registerLazySingleton<JobRepository>(
    () => JobRepository(getIt<JobRemoteDataSource>()),
  );
  getIt.registerFactory<JobPublishCubit>(
    () => JobPublishCubit(getIt<JobRepository>()),
  );

  // publish job - job details (للـ employer / publish flow)
  getIt.registerLazySingleton<JobDetailsRemoteDataSource>(
    () => JobDetailsRemoteDataSource(),
  );
  getIt.registerLazySingleton<JobDetailsRepo>(
    () => JobDetailsRepo(getIt<JobDetailsRemoteDataSource>()),
  );
  getIt.registerFactory<JobDetailsCubit>(
    () => JobDetailsCubit(getIt<JobDetailsRepo>()),
  );

  // worker - jobs
  getIt.registerLazySingleton<JobsRepo>(() => JobsRepo(getIt()));
  getIt.registerFactory<OpenJobsCubit>(() => OpenJobsCubit(getIt()));

  // worker - job details
  getIt.registerFactory<worker_cubit.JobDetailsCubit>(
    () => worker_cubit.JobDetailsCubit(getIt<JobsRepo>()),
  );

  getIt.registerLazySingleton<JobsRecommendationsRepo>(
  () => JobsRecommendationsRepo(getIt()),
);
getIt.registerFactory<JobsRecommendationsCubit>(
  () => JobsRecommendationsCubit(getIt()),
);

getIt.registerLazySingleton<ApplyJobRepo>(
  () => ApplyJobRepo(getIt()),
);
getIt.registerFactory<ApplyJobCubit>(
  () => ApplyJobCubit(getIt()),
);
getIt.registerLazySingleton<UpdateImageProfileRepo>(
    () => UpdateImageProfileRepo(getIt()),
  );
  getIt.registerFactory<UpdateImageProfileCubit>(
    () => UpdateImageProfileCubit(getIt()),
  );

  getIt.registerLazySingleton<UpdateProfileRepo>(
    () => UpdateProfileRepo(getIt()),
  );
  getIt.registerFactory<UpdateProfileCubit>(() => UpdateProfileCubit(getIt()));

  getIt.registerLazySingleton<SupportRepo>(() => SupportRepo(getIt()));
  getIt.registerFactory<SupportCubit>(() => SupportCubit(getIt()));


  getIt.registerLazySingleton<ChangePasswordRepo>(
    () => ChangePasswordRepo(getIt()),
  );
  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(getIt()),
  );
  // getIt.registerLazySingleton<UpdateFcmRepo>(() => UpdateFcmRepo(getIt()));
  // getIt.registerFactory<UpdateFcmCubit>(() => UpdateFcmCubit(getIt()));

  // getIt.registerLazySingleton<GetAllNotificationsRepo>(
  //   () => GetAllNotificationsRepo(getIt()),
  // );
  // getIt.registerFactory<GetAllNotificationsCubit>(
  //   () => GetAllNotificationsCubit(getIt()),
  // );

  // getIt.registerLazySingleton<NotificationsRepo>(
  //   () => NotificationsRepo(getIt()),
  // );
  // getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit(getIt()));
}
