import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';
import 'package:sheftaya/features/worker/home/data/models/all_jobs/jobs_response.dart';

class SavedJobsService {
  static const String _savedJobsKey = 'saved_jobs';

  static Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  static String _getJobId(dynamic job) {
    try {
      if (job is Map) return (job['id'] ?? job['_id'] ?? '').toString();
      return (job.id ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  static Map<String, dynamic>? _toMap(dynamic job) {
    try {
      if (job is Map<String, dynamic>) return job;
      final json = job.toJson();
      return Map<String, dynamic>.from(json as Map);
    } catch (_) {
      return null;
    }
  }

  static dynamic _fromMap(Map<String, dynamic> map) {
    try {
      if (map.containsKey('salary')) return JobModel.fromJson(map);
      return JobItem.fromJson(map);
    } catch (_) {
      return map;
    }
  }

  static Future<List<Map<String, dynamic>>> _readSavedJobs() async {
    final prefs = await _prefs;
    final rawList = prefs.getStringList(_savedJobsKey) ?? <String>[];
    return rawList
        .map((item) => Map<String, dynamic>.from(jsonDecode(item)))
        .toList();
  }

  static Future<void> _writeSavedJobs(List<Map<String, dynamic>> jobs) async {
    final prefs = await _prefs;
    final encoded = jobs.map(jsonEncode).toList();
    await prefs.setStringList(_savedJobsKey, encoded);
  }

  static Future<List<dynamic>> getSavedJobs() async {
    final jobs = await _readSavedJobs();
    return jobs.map(_fromMap).toList();
  }

  static Future<bool> isSaved(String id) async {
    if (id.isEmpty) return false;
    final jobs = await _readSavedJobs();
    return jobs.any((job) => _getJobId(job) == id);
  }

  static Future<void> saveJobItem(dynamic job) async {
    final id = _getJobId(job);
    if (id.isEmpty) return;

    final jobs = await _readSavedJobs();
    final alreadySaved = jobs.any((item) => _getJobId(item) == id);

    if (!alreadySaved) {
      final jobMap = _toMap(job);
      if (jobMap != null) {
        jobs.add(jobMap);
        await _writeSavedJobs(jobs);
      }
    }
  }

  static Future<void> removeJobById(String id) async {
    if (id.isEmpty) return;
    final jobs = await _readSavedJobs();
    jobs.removeWhere((item) => _getJobId(item) == id);
    await _writeSavedJobs(jobs);
  }

  static Future<void> toggleJobItem(dynamic job) async {
    final id = _getJobId(job);
    if (id.isEmpty) return;
    if (await isSaved(id)) {
      await removeJobById(id);
    } else {
      await saveJobItem(job);
    }
  }
}
