import 'package:json_annotation/json_annotation.dart';

part 'auth_me_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthMeResponse {
  final String? status;
  final AuthMeData? data;

  AuthMeResponse({
    this.status,
    this.data,
  });

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthMeData {
  final AuthMeUser? user;
  final WorkerProfile? workerProfile;
  final EmployerProfile? profile;

  AuthMeData({
    this.user,
    this.workerProfile,
    this.profile,
  });

  factory AuthMeData.fromJson(Map<String, dynamic> json) =>
      _$AuthMeDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AuthMeUser {
  final Discipline? discipline;
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final String? preferredLang;
  final String? city;
  final String? status;
  final List<String>? fcmTokens;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  AuthMeUser({
    this.discipline,
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.preferredLang,
    this.city,
    this.status,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AuthMeUser.fromJson(Map<String, dynamic> json) =>
      _$AuthMeUserFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeUserToJson(this);
}

@JsonSerializable()
class Discipline {
  final int? warnings;
  final int? cancellations;
  final int? noShows;

  Discipline({
    this.warnings,
    this.cancellations,
    this.noShows,
  });

  factory Discipline.fromJson(Map<String, dynamic> json) =>
      _$DisciplineFromJson(json);

  Map<String, dynamic> toJson() => _$DisciplineToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerProfile {
  final ExpectedHourlyRate? expectedHourlyRate;
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final String? education;
  final String? professionalStatus;
  final List<String>? pastExperience;
  final List<String>? jobsLookedFor;
  final int? experienceYears;
  final String? healthCertificate;
  final List<dynamic>? availability;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  WorkerProfile({
    this.expectedHourlyRate,
    this.id,
    this.userId,
    this.education,
    this.professionalStatus,
    this.pastExperience,
    this.jobsLookedFor,
    this.experienceYears,
    this.healthCertificate,
    this.availability,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerProfileToJson(this);
}

@JsonSerializable()
class ExpectedHourlyRate {
  final num? amount;
  final String? currency;

  ExpectedHourlyRate({
    this.amount,
    this.currency,
  });

  factory ExpectedHourlyRate.fromJson(Map<String, dynamic> json) =>
      _$ExpectedHourlyRateFromJson(json);

  Map<String, dynamic> toJson() => _$ExpectedHourlyRateToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmployerProfile {
  @JsonKey(name: '_id')
  final String? id;
  final String? userId;
  final String? companyName;
  final String? companyType;
  final String? companyAddress;
  final String? city;
  final List<String>? companyImages;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  EmployerProfile({
    this.id,
    this.userId,
    this.companyName,
    this.companyType,
    this.companyAddress,
    this.city,
    this.companyImages,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory EmployerProfile.fromJson(Map<String, dynamic> json) =>
      _$EmployerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerProfileToJson(this);
}