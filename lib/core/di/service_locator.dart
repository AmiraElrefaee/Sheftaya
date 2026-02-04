import 'package:get_it/get_it.dart';
import 'package:sheftaya/core/constants/user_cubit.dart';
import 'package:sheftaya/core/networking/api_constants.dart';
import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/dio_factory.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Dio instance
  getIt.registerLazySingleton(() => DioFactory.getDio());

  // Register ApiService
  // getIt.registerLazySingleton<ApiService>(
  //   () => ApiService(getIt(), baseUrl: ApiConstants.apiBaseUrl),
  // );

  // User Cubit - Singleton to maintain user state across the app
   getIt.registerLazySingleton<UserCubit>(() => UserCubit());

  // // login
  // getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  // getIt.registerFactory<LoginCubit>(
  //   () => LoginCubit(getIt(), getIt<UserCubit>()),
  // );

  // // signup
  // getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  // getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));

  // // forget password
  // getIt.registerLazySingleton<ForgetPassRepo>(() => ForgetPassRepo(getIt()));
  // getIt.registerFactory<ForgetPasswordCubit>(
  //   () => ForgetPasswordCubit(getIt()),
  // );

  // // verify password
  // getIt.registerLazySingleton<VerifyPasswordRepo>(
  //   () => VerifyPasswordRepo(getIt()),
  // );
  // getIt.registerFactory<VerifyPasswordCubit>(
  //   () => VerifyPasswordCubit(getIt()),
  // );

  // // create new password
  // getIt.registerLazySingleton<CreateNewPasswordRepo>(
  //   () => CreateNewPasswordRepo(getIt()),
  // );
  // getIt.registerFactory<CreateNewPasswordCubit>(
  //   () => CreateNewPasswordCubit(getIt()),
  // );

  // // verify account
  // getIt.registerLazySingleton<VerifyAccountRepo>(
  //   () => VerifyAccountRepo(getIt()),
  // );
  // getIt.registerFactory<VerifyAccountCubit>(() => VerifyAccountCubit(getIt()));

}
