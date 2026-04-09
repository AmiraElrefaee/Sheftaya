import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/publish_job.dart';
import '../../../domain/repo/job_post_repo.dart';

part 'job_publish_state.dart';

class JobPublishCubit extends Cubit<JobPublishState> {
  final JobRepository _repository;
  JobPublishCubit(this._repository) : super(JobPublishInitial());
  Future<void> createJob(JobModel job) async {
    emit(PublishJobLoading());

    final result = await _repository.publishJob(job);

    result.fold(
          (failure) => emit(PublishJobError(failure.errmessage)),
          (response) {

            final jobId = response.data.id;
        emit(PublishJobSuccess(jobId: jobId));
      },
    );
  }
  // inside JobPublishCubit
  Future<void> updateJob(String jobId, JobModel job) async {
    emit( PublishJobLoading());
    final result = await _repository.updateJob(jobId, job);
    result.fold(
          (error) => emit(PublishJobError( error.errmessage)),
          (response) => emit(PublishJobSuccess(jobId: response.data.id)), // بنرجع نفس الـ ID عشان يروح لصفحة النجاح تاني
    );
  }
}
