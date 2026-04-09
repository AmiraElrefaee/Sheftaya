import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';
import 'package:sheftaya/features/worker/home/data/repos/jobs_repo.dart';

part 'job_details_state.dart';
part 'job_details_cubit.freezed.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {
  final JobsRepo _repo;

  JobDetailsCubit(this._repo) : super(const JobDetailsState.initial());

  Future<String> _getAuthToken() async {
    final token = (await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    )).trim();

    if (token.isEmpty) {
      throw StateError('No token found in shared preferences');
    }

    return token.startsWith('Bearer ') ? token : 'Bearer $token';
  }

  Future<void> fetch({required String jobId}) async {
    emit(const JobDetailsState.loading());

    try {
      final token = await _getAuthToken();
      final res = await _repo.getJobDetails2(jobId: jobId, token: token);

      res.when(
       success: (jobItem) {
  emit(JobDetailsState.success(data: jobItem)); 
},
        failure: (e) {
          emit(JobDetailsState.error(message: e.serverFailure.errmessage));
        },
      );
    } catch (e) {
      emit(JobDetailsState.error(message: e.toString()));
    }
  }
}