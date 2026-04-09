import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';
import 'package:sheftaya/features/worker/home/data/repos/job_recommendation_repo.dart';
import 'package:sheftaya/features/worker/home/logic/job_recommendation/jobs_recommendations_state.dart';

class JobsRecommendationsCubit
    extends Cubit<JobsRecommendationsState<List<JobItem>>> {
  final JobsRecommendationsRepo _repo;

  JobsRecommendationsCubit(this._repo)
    : super(const JobsRecommendationsState.initial());

  Future<void> fetchRecommendations() async {
    emit(const JobsRecommendationsState.loading());

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    final response = await _repo.getRecommendations(token);

    response.when(
      success: (data) {
        final jobs = (data.data ?? [])
            .map((e) => JobItem.fromJson(e.toJson()))
            .toList();
        emit(JobsRecommendationsState.success(jobs));
      },
      failure: (errorHandler) {
        log(
          'JobsRecommendations Error: ${errorHandler.serverFailure.errmessage}',
        );
        emit(
          JobsRecommendationsState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}
