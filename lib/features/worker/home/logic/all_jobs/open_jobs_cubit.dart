import 'package:bloc/bloc.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/repos/jobs_repo.dart';
import 'package:sheftaya/features/worker/home/logic/all_jobs/open_jobs_state.dart';

class OpenJobsCubit extends Cubit<OpenJobsState> {
  final JobsRepo _repo;

  OpenJobsCubit(this._repo) : super(const OpenJobsState.initial());

  int _page = 1;
  final int _limit = 10;
  bool _loadingMore = false;

  Future<String> _getAuthToken() async {
    final token = (await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    )).trim();

    if (token.isEmpty) {
      throw StateError('No token found in shared preferences');
    }

    return token.startsWith('Bearer ') ? token : 'Bearer $token';
  }

  Future<void> fetchOpenJobs() async {
    _page = 1;
    emit(const OpenJobsState.loading());

    try {
      final token = await _getAuthToken();

      final res = await _repo.getOpenJobs(
        page: _page,
        limit: _limit,
        token: token,
      );

      res.when(
        success: (data) {
          emit(
            OpenJobsState.success(
              data: data,
              page: _page,
              hasNextPage: data.hasNextPage ?? false,
            ),
          );
        },
        failure: (e) {
          emit(OpenJobsState.error(message: e.serverFailure.errmessage));
        },
      );
    } catch (e) {
      emit(OpenJobsState.error(message: e.toString()));
    }
  }

  Future<void> loadMore() async {
    state.maybeWhen(
      success: (data, page, hasNextPage) async {
        if (!hasNextPage || _loadingMore) return;

        _loadingMore = true;
        final nextPage = page + 1;

        emit(OpenJobsState.loadingMore(previous: data, nextPage: nextPage));

        try {
          final token = await _getAuthToken();

          final res = await _repo.getOpenJobs(
            page: nextPage,
            limit: _limit,
            token: token,
          );

          res.when(
            success: (newData) {
              final merged = [...?data.data, ...?newData.data];

              emit(
                OpenJobsState.success(
                  data: newData.copyWith(data: merged),
                  page: nextPage,
                  hasNextPage: newData.hasNextPage ?? false,
                ),
              );
            },
            failure: (e) {
              emit(OpenJobsState.error(message: e.serverFailure.errmessage));
            },
          );
        } catch (e) {
          emit(OpenJobsState.error(message: e.toString()));
        }

        _loadingMore = false;
      },
      orElse: () {},
    );
  }
}
