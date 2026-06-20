import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/publish_job.dart';
import '../../../domain/repo/job_post_repo.dart';

part 'job_publish_state.dart';

class JobPublishCubit extends Cubit<JobPublishState> {
  final JobRepository _repository;

  JobPublishCubit(this._repository) : super(JobPublishInitial());

  // ✅ للنشر الجديد
  Future<void> createJob(JobModel job) async {
    emit(PublishJobLoading());
    final result = await _repository.publishJob(job);
    result.fold(
          (failure) => emit(PublishJobError(failure.errmessage)),
          (response) => emit(PublishJobSuccess(jobId: response.data.id)),
    );
  }

  // ✅ للتحديث - تستقبل Map مش JobModel
  Future<void> updateJob(String jobId, Map<String, dynamic> jobData) async {
    emit(PublishJobLoading());
    final result = await _repository.updateJob(jobId, jobData);
    result.fold(
          (failure) => emit(PublishJobError(failure.errmessage)),
          (response) => emit(PublishJobSuccess(jobId: response.data.id)),
    );
  }
}