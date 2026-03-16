import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/job_details_response.dart';
import '../../../domain/repo/job_details_repo.dart';

part 'job_details_state.dart';

class JobDetailsCubit extends Cubit<JobDetailsState> {

  final JobDetailsRepo repo;

  JobDetailsCubit(this.repo) : super(JobDetailsInitial());

  Future<void> getJobDetails(String jobId) async {
    emit(JobDetailsLoading());

    try {
      final  JobDetails job = await repo.getJobDetails(jobId);

      emit(JobDetailsSuccess(job));
    } catch (e) {
      emit(JobDetailsError(e.toString()));
    }
  }
}
