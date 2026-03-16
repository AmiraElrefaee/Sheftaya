import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/publish_job.dart';
import '../../../data/model/publish_job_request.dart';
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
}
