import 'package:json_annotation/json_annotation.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

part 'job_details_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployerJobDetailsResponse {
  final String? status;
  final JobDetailsData? data;

  EmployerJobDetailsResponse({this.status, this.data});

  factory EmployerJobDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$EmployerJobDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerJobDetailsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobDetailsData {
  final JobDetails? job;
  final bool? isFull;
  final bool? isOwner;
  final List<ApplicationData>? applications;
  final MyApplicationData? myApplication;

  JobDetailsData({
    this.job,
    this.isFull,
    this.isOwner,
    this.applications,
    this.myApplication,
  });

  factory JobDetailsData.fromJson(Map<String, dynamic> json) =>
      _$JobDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailsDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApplicationData {
  @JsonKey(name: '_id')
  final String? id;
  final String? status;
  final WorkerInfo? workerId;
  final String? createdAt;

  ApplicationData({
    this.id,
    this.status,
    this.workerId,
    this.createdAt,
  });

  factory ApplicationData.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MyApplicationData {
  @JsonKey(name: '_id')
  final String? id;
  final String? status;
  final String? createdAt;

  MyApplicationData({
    this.id,
    this.status,
    this.createdAt,
  });

  factory MyApplicationData.fromJson(Map<String, dynamic> json) =>
      _$MyApplicationDataFromJson(json);

  Map<String, dynamic> toJson() => _$MyApplicationDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerInfo {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? city;
  final String? imageProfile;
  final num? rating;
  final num? ratingAverage;

  WorkerInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.city,
    this.imageProfile,
    this.rating,
    this.ratingAverage,
  });

  factory WorkerInfo.fromJson(Map<String, dynamic> json) =>
      _$WorkerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerInfoToJson(this);
}