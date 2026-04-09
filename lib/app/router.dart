import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/employer/home/presentation/employer_home_screen.dart';
import 'package:sheftaya/features/employer/home/presentation/widgets/my_posted_jobs_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/create_new_password_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/forget_pass_screen.dart';
import 'package:sheftaya/features/forget_password/presentation/verify_password_screen.dart';
import 'package:sheftaya/features/login/presentation/login_screen.dart';
import 'package:sheftaya/features/on_boarding_screen.dart/on_boarding_screen.dart';
import 'package:sheftaya/features/sign_up/presentation/sign_up_screen.dart';
import 'package:sheftaya/features/sign_up/presentation/verify_account_screen.dart';
import 'package:sheftaya/features/worker/home/data/models/review_model.dart';
import 'package:sheftaya/features/worker/home/logic/apply_for_job/apply_job_cubit.dart';
import 'package:sheftaya/features/worker/home/logic/job_details/job_details_cubit.dart'
    as worker_cubit;
import 'package:sheftaya/features/worker/home/presentation/widgets/all_jobs_screen.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/job_details.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/job_reviews.dart';
import 'package:sheftaya/features/worker/home/presentation/widgets/search_screen.dart';
import 'package:sheftaya/features/worker/home/presentation/worker_home_screen.dart';

import '../core/di/service_locator.dart';
import '../features/publish_job/data/model/job_details_response.dart'
    as publish_job;
import '../features/publish_job/presentation/job_publish_success_screen.dart';
import '../features/publish_job/presentation/mangers/job_details_cubit/job_details_cubit.dart';
import '../features/publish_job/presentation/map_picker_screen.dart';
import '../features/publish_job/presentation/publish_job_view.dart';
import '../features/shift_details/presentation/shift_details_view.dart';
import '../features/term_condition/presentation/term_condtion_view.dart';

abstract class AppRouter {
  static const kSignUpScreen = '/signUpScreen';
  static const kLoginScreen = '/loginScreen';
  static const kOnBoardingScreen = '/';
  static const kEmployerHomeScreen = '/employerHomeScreen';
  static const kWorkerHomeScreen = '/workerHomeScreen';
  static const kForgetPassScreen = '/forgetPassScreen';
  static const kVerifyPasswordScreen = '/verifyPasswordScreen';
  static const kCreateNewPasswordScreen = '/createNewPasswordScreen';
  static const kVerifyAccountScreen = '/verifyAccountScreen';
  static const kSearchScreen = '/searchScreen';
  static const kAllJobsScreen = '/allJobsScreen';
  static const kJobDetailsScreen = '/jobDetailsScreen';
  static const kJobReviewsScreen = '/jobReviewsScreen';
  static const kMyPostedJobsScreen = '/myPostedJobsScreen';
  static const kPublishJobView = '/PublishJobView';
  static const kTermCondtionView = '/TermCondtionView';
  static const kPublishJobNewLocation = '/PublishJobNewLocation';
  static const kJobPublishSuccessScreen = '/JobPublishSuccessScreen';
  static const kMapPickerScreen = '/MapPickerScreen';
  static const kShiftDetailsView = '/ShiftDetailsView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kOnBoardingScreen,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: kSignUpScreen,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: kLoginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kEmployerHomeScreen,
        builder: (context, state) => const EmployerHomeScreen(),
      ),
      GoRoute(
        path: kWorkerHomeScreen,
        builder: (context, state) => const WorkerHomeScreen(),
      ),
      GoRoute(
        path: kForgetPassScreen,
        builder: (context, state) => const ForgetPassScreen(),
      ),
      GoRoute(
        path: kPublishJobView,
        builder: (context, state) {
          final job = state.extra as publish_job.JobDetails?;
          return PublishJobView(existingJob: job);
        },
      ),
      GoRoute(
        path: kVerifyPasswordScreen,
        builder: (context, state) {
          final email = state.extra as String;
          return VerifyPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: kCreateNewPasswordScreen,
        builder: (context, state) {
          final token = state.extra as String;
          return CreateNewPasswordScreen(resetToken: token);
        },
      ),
      GoRoute(
        path: kVerifyAccountScreen,
        builder: (context, state) {
          final role = state.extra as String;
          return VerifyAccountScreen(role: role);
        },
      ),
      GoRoute(
        path: kSearchScreen,
        builder: (context, state) {
          final jobs = state.extra as List<dynamic>;
          return SearchJobsScreen(jobs: jobs);
        },
      ),
      GoRoute(
        path: kAllJobsScreen,
        builder: (context, state) {
          final data = state.extra as Map;
          return AllJobsScreen(title: data['title'], jobs: data['jobs']);
        },
      ),
      GoRoute(
        path: AppRouter.kJobDetailsScreen,
        builder: (context, state) {
          final jobId = state.extra as String;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<worker_cubit.JobDetailsCubit>(),
              ),
              BlocProvider(create: (context) => getIt<ApplyJobCubit>()),
            ],
            child: JobDetails(jobId: jobId),
          );
        },
      ),
      GoRoute(
        path: kJobReviewsScreen,
        builder: (context, state) {
          final reviews = state.extra as List<ReviewModel>;
          return JobReviews(reviews: reviews);
        },
      ),
      GoRoute(
        path: kMyPostedJobsScreen,
        builder: (context, state) {
          final jobs = state.extra as List<JobModel>;
          return MyPostedJobsScreen(jobs: jobs);
        },
      ),
      GoRoute(
        path: kTermCondtionView,
        builder: (context, state) => const TermCondtionView(),
      ),
      GoRoute(
        path: kJobPublishSuccessScreen,
        builder: (context, state) {
          final String jobId = state.extra as String;
          return BlocProvider(
            create: (_) => getIt<JobDetailsCubit>(), // ✅ publish_job cubit
            child: JobPublishSuccessScreen(jobId: jobId),
          );
        },
      ),
      GoRoute(
        path: kMapPickerScreen,
        builder: (context, state) => MapPickerScreen(),
      ),
      GoRoute(
        path: kShiftDetailsView,
        builder: (context, state) => ShiftDetailsView(),
      ),
    ],
  );
}
