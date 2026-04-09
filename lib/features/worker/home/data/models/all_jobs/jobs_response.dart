import 'package:json_annotation/json_annotation.dart';

part 'jobs_response.g.dart';

@JsonSerializable(explicitToJson: true)
class JobsResponse {
  final String? status;
  final int? page;
  final int? results;
  final int? totalResults;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;
  final List<JobItem>? data;

  JobsResponse({
    this.status,
    this.page,
    this.results,
    this.totalResults,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
    this.data,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) =>
      _$JobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobsResponseToJson(this);

  JobsResponse copyWith({
    String? status,
    int? page,
    int? results,
    int? totalResults,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPrevPage,
    List<JobItem>? data,
  }) {
    return JobsResponse(
      status: status ?? this.status,
      page: page ?? this.page,
      results: results ?? this.results,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
      data: data ?? this.data,
    );
  }
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
  final String? endDateTime;
  final int? dailyWorkHours;
  final int? requiredWorkers;
  final int? acceptedWorkersCount;
  final PricePerHour? pricePerHour;
  final String? experienceLevel;
  final String? status;
  final String? details;
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
    this.endDateTime,
    this.dailyWorkHours,
    this.requiredWorkers,
    this.acceptedWorkersCount,
    this.pricePerHour,
    this.experienceLevel,
    this.status,
    this.details,
    this.employerId,
    this.createdAt,
    this.updatedAt,
  });

  factory JobItem.fromJson(Map<String, dynamic> json) =>
      _$JobItemFromJson(json);

  Map<String, dynamic> toJson() => _$JobItemToJson(this);
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

  JobLocation({this.type, this.coordinates, this.mainPlace, this.address});

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