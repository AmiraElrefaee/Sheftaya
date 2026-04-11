import 'package:json_annotation/json_annotation.dart';

part 'job_recommendation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class JobRecommendationResponse {
  final String? status;
  final int? results;
  final List<JobItem>? data;

  JobRecommendationResponse({
    this.status,
    this.results,
    this.data,
  });

  factory JobRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobRecommendationResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobItem {
  @JsonKey(name: '_id')
  final String? id;

  final String? title;
  final List<String>? requiredSkills;

  @JsonKey(name: 'JobImages')
  final List<String>? jobImages;

  final String? place;
  final JobLocation? location;

  final String? startDateTime;
  final String? startTime;
  final String? endDateTime;

  final int? dailyWorkHours;
  final int? workHours;

  final int? requiredWorkers;
  final int? acceptedWorkersCount;

  final PricePerHour? pricePerHour;
  final String? experienceLevel;
  final String? status;
  final String? details;

  final JobCompanyDetails? companyDetails;

  final String? companyName;
  final String? companyImage;
  final num? score;

  final JobEmployerId? employerId;
  final String? createdAt;
  final String? updatedAt;

  JobItem({
    this.id,
    this.title,
    this.requiredSkills,
    this.jobImages,
    this.place,
    this.location,
    this.startDateTime,
    this.startTime,
    this.endDateTime,
    this.dailyWorkHours,
    this.workHours,
    this.requiredWorkers,
    this.acceptedWorkersCount,
    this.pricePerHour,
    this.experienceLevel,
    this.status,
    this.details,
    this.companyDetails,
    this.companyName,
    this.companyImage,
    this.score,
    this.employerId,
    this.createdAt,
    this.updatedAt,
  });

  factory JobItem.fromJson(Map<String, dynamic> json) =>
      _$JobItemFromJson(json);

  Map<String, dynamic> toJson() => _$JobItemToJson(this);

  String? get normalizedStartDateTime => startDateTime ?? startTime;
  int? get normalizedWorkHours => dailyWorkHours ?? workHours;
}

@JsonSerializable(explicitToJson: true)
class JobCompanyDetails {
  final String? companyName;
  final String? companyType;
  final String? companyAddress;
  final String? companyCity;
  final String? companyContactPersonName;
  final List<String>? companyImages;

  JobCompanyDetails({
    this.companyName,
    this.companyType,
    this.companyAddress,
    this.companyCity,
    this.companyContactPersonName,
    this.companyImages,
  });

  factory JobCompanyDetails.fromJson(Map<String, dynamic> json) =>
      _$JobCompanyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$JobCompanyDetailsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobEmployerId {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;

  JobEmployerId({this.id, this.firstName, this.lastName});

  factory JobEmployerId.fromJson(Map<String, dynamic> json) =>
      _$JobEmployerIdFromJson(json);

  Map<String, dynamic> toJson() => _$JobEmployerIdToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobLocation {
  final String? type;
  final List<num>? coordinates;
  final String? mainPlace;
  final String? address;

  JobLocation({
    this.type,
    this.coordinates,
    this.mainPlace,
    this.address,
  });

  factory JobLocation.fromJson(Map<String, dynamic> json) =>
      _$JobLocationFromJson(json);

  Map<String, dynamic> toJson() => _$JobLocationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PricePerHour {
  final num? amount;
  final String? currency;

  PricePerHour({this.amount, this.currency});

  factory PricePerHour.fromJson(Map<String, dynamic> json) =>
      _$PricePerHourFromJson(json);

  Map<String, dynamic> toJson() => _$PricePerHourToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerJobDetailsResponse {
  final String? status;
  final WorkerJobDetailsData? data;

  WorkerJobDetailsResponse({this.status, this.data});

  factory WorkerJobDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkerJobDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerJobDetailsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerJobDetailsData {
  final JobItem? job;

  WorkerJobDetailsData({this.job});

  factory WorkerJobDetailsData.fromJson(Map<String, dynamic> json) =>
      _$WorkerJobDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerJobDetailsDataToJson(this);
}