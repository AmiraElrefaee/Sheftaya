import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/repos/apply_job_repo.dart';
import 'apply_job_state.dart';

class ApplyJobCubit extends Cubit<ApplyJobState> {
  final ApplyJobRepo _repo;

  ApplyJobCubit(this._repo) : super(const ApplyJobState.initial());

  Future<void> applyForJob(String jobId) async {
    emit(const ApplyJobState.loading());

    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);

    final response = await _repo.applyForJob(jobId, token);

    response.when(
      success: (data) {
        // احفظ الـ appId
        final appId = data.data?['_id'] as String? ?? '';
        if (appId.isNotEmpty) {
          SharedPrefHelper.setSecuredString('appId_${data.data?['jobId']}', appId);
        }
        emit(ApplyJobState.success(data));
      },
      failure: (errorHandler) {
        log('ApplyJob Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          ApplyJobState.error(
            error: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }
}