import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart' hide Success;
import 'package:sheftaya/features/employer/my_jobs/data/models/job_applications_response.dart';
import 'package:sheftaya/features/employer/my_jobs/data/repos/job_applications_repo.dart';
import 'package:sheftaya/features/employer/my_jobs/logic/job_applications_state.dart';

class JobApplicationsCubit extends Cubit<JobApplicationsState> {
  final JobApplicationsRepo _repo;

  JobApplicationsCubit(this._repo)
    : super(const JobApplicationsState.initial());

  static const int defaultPage = 1;
  static const int defaultLimit = 20;

  String? _currentJobId;
  int _currentPage = defaultPage;
  int _limit = defaultLimit;
  String? _status;
  bool _isLoadingMore = false;

  Future<void> fetchApplicationsForJob(
    String jobId, {
    int page = defaultPage,
    int limit = defaultLimit,
    String? status,
  }) async {
    _currentJobId = jobId;
    _currentPage = page;
    _limit = limit;
    _status = status;

    emit(const JobApplicationsState.loading());

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    final response = await _repo.getApplicationsForJob(
      jobId,
      page: page,
      limit: limit,
      status: status,
      token: 'Bearer $token',
    );

    response.when(
      success: (data) {
        emit(
          JobApplicationsState.success(
            data: data,
            page: data.page ?? page,
            limit: data.totalResults != null ? limit : _limit,
            status: status,
            hasNextPage: data.hasNextPage ?? false,
          ),
        );
      },
      failure: (errorHandler) {
        log('JobApplications Error: ${errorHandler.serverFailure.errmessage}');
        emit(
          JobApplicationsState.error(
            message: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;

    if (_isLoadingMore) return;

    if (currentState is! Success) return;

    if (!currentState.hasNextPage) return;

    if (_currentJobId == null) return;

    _isLoadingMore = true;
    final nextPage = currentState.page + 1;

    emit(
      JobApplicationsState.loadingMore(
        previous: currentState.data,
        nextPage: nextPage,
      ),
    );

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    final response = await _repo.getApplicationsForJob(
      _currentJobId!,
      page: nextPage,
      limit: _limit,
      status: _status,
      token: 'Bearer $token',
    );

    response.when(
      success: (data) {
        final merged = _mergeResponses(currentState.data, data);
        emit(
          JobApplicationsState.success(
            data: merged,
            page: nextPage,
            limit: _limit,
            status: _status,
            hasNextPage: data.hasNextPage ?? false,
          ),
        );
        _currentPage = nextPage;
      },
      failure: (errorHandler) {
        emit(
          JobApplicationsState.error(
            message: errorHandler.serverFailure.errmessage,
          ),
        );
      },
    );

    _isLoadingMore = false;
  }

  Future<void> acceptWorker({
    required String jobId,
    required String applicationId,
  }) async {
    final currentState = state;

    if (currentState is Success) {
      emit(JobApplicationsState.accepting(previous: currentState.data));
    } else {
      emit(const JobApplicationsState.loading());
    }

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    final response = await _repo.acceptWorker(
      jobId,
      applicationId,
      'Bearer $token',
    );

    response.when(
      success: (data) async {
        await fetchApplicationsForJob(
          jobId,
          page: _currentPage,
          limit: _limit,
          status: _status,
        );
      },
      failure: (errorHandler) {
        log('AcceptWorker Error: ${errorHandler.serverFailure.errmessage}');
        if (currentState is Success) {
          emit(currentState);
        } else {
          emit(
            JobApplicationsState.error(
              message: errorHandler.serverFailure.errmessage,
            ),
          );
        }
      },
    );
  }

  JobApplicationsResponse _mergeResponses(
    JobApplicationsResponse previous,
    JobApplicationsResponse next,
  ) {
    final merged = <JobApplicationItem>[];
    if (previous.data != null) {
      merged.addAll(previous.data!);
    }
    if (next.data != null) {
      merged.addAll(next.data!);
    }

    return JobApplicationsResponse(
      status: next.status ?? previous.status,
      page: next.page ?? previous.page,
      results: merged.length,
      totalResults: next.totalResults ?? previous.totalResults,
      totalPages: next.totalPages ?? previous.totalPages,
      hasNextPage: next.hasNextPage ?? previous.hasNextPage,
      hasPrevPage: next.hasPrevPage ?? previous.hasPrevPage,
      data: merged,
    );
  }
}
