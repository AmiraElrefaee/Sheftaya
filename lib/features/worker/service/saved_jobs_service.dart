import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';

class SavedJobsService {
  static const _key = 'saved_jobs';

  static Future<List<JobModel>> getSavedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => JobModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> toggleJob(JobModel job) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];

    final exists = data.any(
      (e) => JobModel.fromJson(jsonDecode(e)).id == job.id,
    );

    if (exists) {
      data.removeWhere(
        (e) => JobModel.fromJson(jsonDecode(e)).id == job.id,
      );
    } else {
      data.add(jsonEncode(job.toJson()));
    }

    await prefs.setStringList(_key, data);
  }

  static Future<bool> isSaved(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.any(
      (e) => JobModel.fromJson(jsonDecode(e)).id == jobId,
    );
  }
}