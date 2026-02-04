import 'package:go_router/go_router.dart';
import 'package:sheftaya/features/employer/home/presentation/home_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/create_new_password_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/forget_pass_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/verify_password_screen.dart';
import 'package:sheftaya/features/login/presentation/login_screen.dart';
import 'package:sheftaya/features/on_boarding_screen.dart/on_boarding_screen.dart';
import 'package:sheftaya/features/sign_up/presentation/sign_up_screen.dart';
import 'package:sheftaya/features/sign_up/presentation/verify_account_screen.dart';

abstract class AppRouter {
  static const kSignUpScreen = '/signUpScreen';
  static const kLoginScreen = '/loginScreen';
  static const kOnBoardingScreen = '/';
  static const kHomeScreen = '/HomeScreen';
  static const kForgetPassScreen = '/forgetPassScreen';
  static const kVerifyPasswordScreen = '/verifyPasswordScreen';
  static const kCreateNewPasswordScreen = '/createNewPasswordScreen';
  static const kVerifyAccountScreen = '/verifyAccountScreen';
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kOnBoardingScreen,
        builder: (context, state) {
          return const OnBoardingScreen();
        },
      ),
      GoRoute(
        path: kSignUpScreen,
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: kHomeScreen,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
     

      GoRoute(
        path: AppRouter.kForgetPassScreen,
        builder: (context, state) {
          return const ForgetPassScreen();
        },
      ),
      GoRoute(
        path: kVerifyPasswordScreen,
        builder: (context, state) {
          return const VerifyPasswordScreen();
        },
      ),
      GoRoute(
        path: kCreateNewPasswordScreen,
        builder: (context, state) {
          return const CreateNewPasswordScreen();
        },
      ),
      GoRoute(
        path: kVerifyAccountScreen,
        builder: (context, state) {
          return const VerifyAccountScreen();
        },
      ),
    ],
  );
}
