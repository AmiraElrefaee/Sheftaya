import 'package:json_annotation/json_annotation.dart';

part 'job_applications_response.g.dart';

@JsonSerializable(explicitToJson: true)
class JobApplicationsResponse {
  final String? status;
  final int? page;
  final int? results;
  final int? totalResults;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;
  final List<JobApplicationItem>? data;

  JobApplicationsResponse({
    this.status,
    this.page,
    this.results,
    this.totalResults,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.data,
  });

  factory JobApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobApplicationsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobApplicationItem {
  @JsonKey(name: '_id')
  final String? id;
  final String? status;
  final String? arrivalStatus;
  final String? createdAt;
  final WorkerBasicInfo? workerId;
  final WorkerProfileInfo? workerProfile;

  JobApplicationItem({
    this.id,
    this.status,
    this.arrivalStatus,
    this.createdAt,
    this.workerId,
    this.workerProfile,
  });

  factory JobApplicationItem.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationItemFromJson(json);

  Map<String, dynamic> toJson() => _$JobApplicationItemToJson(this);
}

@JsonSerializable()
class WorkerBasicInfo {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? profileImage;

  WorkerBasicInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.city,
    this.profileImage,
  });

  factory WorkerBasicInfo.fromJson(Map<String, dynamic> json) =>
      _$WorkerBasicInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerBasicInfoToJson(this);
}

@JsonSerializable()
class WorkerProfileInfo {
  final String? userId;
  final dynamic pastExperience;
  final int? experienceYears;
  final dynamic expectedHourlyRate;

  WorkerProfileInfo({
    this.userId,
    this.pastExperience,
    this.experienceYears,
    this.expectedHourlyRate,
  });

  factory WorkerProfileInfo.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerProfileInfoToJson(this);
}