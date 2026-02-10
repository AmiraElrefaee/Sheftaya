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
import 'package:sheftaya/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:sheftaya/features/sign_up/data/repo/verify_sign_up_repo.dart';
import 'package:sheftaya/features/sign_up/logic/sign_up/sign_up_cubit.dart';
import 'package:sheftaya/features/sign_up/logic/verify_sign_up/verify_signup_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Dio instance
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // Register ApiService
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt(), baseUrl: ApiConstants.apiBaseUrl),
  );

  // User Cubit - Singleton to maintain user state across the app
  getIt.registerLazySingleton<UserCubit>(() => UserCubit());

  // login
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt(), getIt<UserCubit>()),
  );

  // signup
  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
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
  getIt.registerFactory<VerifyPasswordCubit>(
    () => VerifyPasswordCubit(getIt()),
  );

  // create new password
  getIt.registerLazySingleton<CreateNewPasswordRepo>(
    () => CreateNewPasswordRepo(getIt()),
  );
  getIt.registerFactory<CreateNewPasswordCubit>(
    () => CreateNewPasswordCubit(getIt()),
  );

  // verify account
  getIt.registerLazySingleton<VerifySignupRepo>(
    () => VerifySignupRepo(getIt()),
  );
  getIt.registerFactory<VerifySignupCubit>(
    () => VerifySignupCubit(getIt(), getIt<UserCubit>()),
  );
}
