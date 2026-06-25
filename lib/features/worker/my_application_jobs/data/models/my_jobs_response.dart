import 'package:json_annotation/json_annotation.dart';

part 'my_jobs_response.g.dart';

@JsonSerializable(explicitToJson: true)
class MyJobsResponse {
  final String? status;
  final int? results;
  final List<MyJobItem>? data;

  MyJobsResponse({
    this.status,
    this.results,
    this.data,
  });

  factory MyJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$MyJobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyJobsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MyJobItem {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? place;
  final String? postedAt;
  final String? finalStatus;
  final String? jobStatus;
  final JobDetails? job;
  final String? applicationStatus;
  final String? arrivalStatus;
  final String? appliedAt;
  final String? applicationId; // ← أضيفي السطر ده

  MyJobItem({
    this.id,
    this.title,
    this.place,
    this.postedAt,
    this.finalStatus,
    this.jobStatus,
    this.job,
    this.applicationStatus,
    this.arrivalStatus,
    this.appliedAt,
    this.applicationId, // ← وهنا
  });

  factory MyJobItem.fromJson(Map<String, dynamic> json) =>
      _$MyJobItemFromJson(json);

  Map<String, dynamic> toJson() => _$MyJobItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobDetails {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final List<String>? jobImages;
  final String? place;
  final JobLocation? location;
  final String? startDateTime;
  final String? endDateTime;  // ← أضيفي هذا السطر
  final int? dailyWorkHours;
  final int? requiredWorkers;
  final int? acceptedWorkersCount;
  final PricePerHour? pricePerHour;
  final String? details;
  final CompanyDetails? companyDetails;
  final String? status;
  final PaymentDetails? payment;
  final String? createdAt;

  JobDetails({
    this.id,
    this.title,
    this.jobImages,
    this.place,
    this.location,
    this.startDateTime,
    this.endDateTime,  // ← وأضيفيه هنا
    this.dailyWorkHours,
    this.requiredWorkers,
    this.acceptedWorkersCount,
    this.pricePerHour,
    this.details,
    this.companyDetails,
    this.status,
    this.payment,
    this.createdAt,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) =>
      _$JobDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailsToJson(this);
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

@JsonSerializable()
class PricePerHour {
  final num? amount;
  final String? currency;

  PricePerHour({
    this.amount,
    this.currency,
  });

  factory PricePerHour.fromJson(Map<String, dynamic> json) =>
      _$PricePerHourFromJson(json);

  Map<String, dynamic> toJson() => _$PricePerHourToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CompanyDetails {
  final String? companyName;
  final String? companyType;
  final String? companyAddress;
  final String? companyCity;
  final String? companyContactPersonName;
  final List<String>? companyImages;

  CompanyDetails({
    this.companyName,
    this.companyType,
    this.companyAddress,
    this.companyCity,
    this.companyContactPersonName,
    this.companyImages,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) =>
      _$CompanyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyDetailsToJson(this);
}

@JsonSerializable()
class PaymentDetails {
  final String? method;
  final String? status;
  final num? totalAmount;
  final num? platformFee;

  PaymentDetails({
    this.method,
    this.status,
    this.totalAmount,
    this.platformFee,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailsToJson(this);
}