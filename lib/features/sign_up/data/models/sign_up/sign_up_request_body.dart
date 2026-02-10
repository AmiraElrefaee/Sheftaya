import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class SignupRequestBody {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String role; // employer | worker

  final String? phone;
  final String? preferredLang;
  final String? city;
  final String? birthDate;

  // صور الهوية والصورة الشخصية
  final String? frontIdImage;
  final String? backIdImage;
  final String? selfieImage;

  final EmployerProfile? employerProfile;
  final WorkerProfile? workerProfile;

  SignupRequestBody({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    this.phone,
    this.preferredLang,
    this.city,
    this.birthDate,
    this.frontIdImage,
    this.backIdImage,
    this.selfieImage,
    this.employerProfile,
    this.workerProfile,
  });

  factory SignupRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestBodyToJson(this);
}

@JsonSerializable()
class EmployerProfile {
  final String companyName;
  final String companyType;
  final String companyAddress;
  final String city;
  
  // صور المؤسسة
  final List<String>? companyImages;

  EmployerProfile({
    required this.companyName,
    required this.companyType,
    required this.companyAddress,
    required this.city,
    this.companyImages,
  });

  factory EmployerProfile.fromJson(Map<String, dynamic> json) =>
      _$EmployerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerProfileToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WorkerProfile {
  final String education;
  final String professionalStatus;
  final List<String> pastExperience;
  final List<String> jobsLookedFor;
  final int experienceYears;
  final List<Availability> availability;
  final ExpectedHourlyRate expectedHourlyRate;
  
  // شهادة صحية
  final String? healthCertificate;

  WorkerProfile({
    required this.education,
    required this.professionalStatus,
    required this.pastExperience,
    required this.jobsLookedFor,
    required this.experienceYears,
    required this.availability,
    required this.expectedHourlyRate,
    this.healthCertificate,
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerProfileToJson(this);
}

@JsonSerializable()
class Availability {
  final String day;
  final String from;
  final String to;

  Availability({required this.day, required this.from, required this.to});

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);
}

@JsonSerializable()
class ExpectedHourlyRate {
  final num amount;
  final String currency;

  ExpectedHourlyRate({required this.amount, required this.currency});

  factory ExpectedHourlyRate.fromJson(Map<String, dynamic> json) =>
      _$ExpectedHourlyRateFromJson(json);

  Map<String, dynamic> toJson() => _$ExpectedHourlyRateToJson(this);
}