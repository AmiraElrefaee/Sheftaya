import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/repos/open_jobs_repo.dart';
import 'open_jobs_state.dart';

class OpenJobsCubit extends Cubit<OpenJobsState> {
  final OpenJobsRepo _repo;

  OpenJobsCubit(this._repo) : super(const OpenJobsState.initial());

  Future<void> fetchOpenJobs() async {
    emit(const OpenJobsState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final response = await _repo.getOpenJobs(
      token: 'Bearer $token',
    );

    response.when(
      success: (data) {
        emit(OpenJobsState.success(data));
      },
      failure: (errorHandler) {
        log('OpenJobs Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          OpenJobsState.error(
            message: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}