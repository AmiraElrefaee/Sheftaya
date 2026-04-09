import 'package:sheftaya/core/networking/api_service.dart';
import 'package:sheftaya/core/networking/server_error_handler.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';

class JobsRepo {
  final ApiService _api;

  JobsRepo(this._api);

  Future<ServerResult<JobsResponse>> getOpenJobs({
    int? page,
    int? limit,
    required String token,
  }) async {
    try {
      final res = await _api.getOpenJobs(
        page: page,
        limit: limit,
        token: token,
      );
      return ServerResult.success(res);
    } catch (e) {
      return ServerResult.failure(ServerErrorHandler.handle(e));
    }
  }

  Future<ServerResult<JobItem>> getJobDetails2({
    required String jobId,
    required String token,
  }) async {
    try {
      final res = await _api.getJobDetails2(jobId: jobId, token: token);
      final job = res.data?.job;
      if (job == null) {
        throw Exception('لم يتم العثور على الوظيفة');
      }
      return ServerResult.success(job);
    } catch (e) {
      return ServerResult.failure(ServerErrorHandler.handle(e));
    }
  }
}
