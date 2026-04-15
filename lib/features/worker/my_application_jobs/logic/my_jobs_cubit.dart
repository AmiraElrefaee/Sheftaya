import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/repos/my_jobs_repo.dart';
import 'my_jobs_state.dart';

class MyJobsCubit extends Cubit<MyJobsState> {
  final MyJobsRepo _repo;

  MyJobsCubit(this._repo) : super(const MyJobsState.initial());

  Future<void> fetchMyJobs() async {
    emit(const MyJobsState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final response = await _repo.getMyJobs('Bearer $token');

    response.when(
      success: (data) {
        emit(MyJobsState.success(data));
      },
      failure: (errorHandler) {
        log('MyJobs Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          MyJobsState.error(
            message: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}