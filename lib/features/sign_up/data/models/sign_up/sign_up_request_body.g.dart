// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupRequestBody _$SignupRequestBodyFromJson(Map<String, dynamic> json) =>
    SignupRequestBody(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String?,
      preferredLang: json['preferredLang'] as String?,
      city: json['city'] as String?,
      birthDate: json['birthDate'] as String?,
      employerProfile: json['employerProfile'] == null
          ? null
          : EmployerProfile.fromJson(
              json['employerProfile'] as Map<String, dynamic>,
            ),
      workerProfile: json['workerProfile'] == null
          ? null
          : WorkerProfile.fromJson(
              json['workerProfile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$SignupRequestBodyToJson(SignupRequestBody instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'role': instance.role,
      'phone': instance.phone,
      'preferredLang': instance.preferredLang,
      'city': instance.city,
      'birthDate': instance.birthDate,
      'employerProfile': instance.employerProfile?.toJson(),
      'workerProfile': instance.workerProfile?.toJson(),
    };

EmployerProfile _$EmployerProfileFromJson(Map<String, dynamic> json) =>
    EmployerProfile(
      companyName: json['companyName'] as String,
      companyType: json['companyType'] as String,
      companyAddress: json['companyAddress'] as String,
      city: json['city'] as String,
    );

Map<String, dynamic> _$EmployerProfileToJson(EmployerProfile instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'companyType': instance.companyType,
      'companyAddress': instance.companyAddress,
      'city': instance.city,
    };

WorkerProfile _$WorkerProfileFromJson(Map<String, dynamic> json) =>
    WorkerProfile(
      education: json['education'] as String,
      professionalStatus: json['professionalStatus'] as String,
      pastExperience: (json['pastExperience'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      jobsLookedFor: (json['jobsLookedFor'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      experienceYears: (json['experienceYears'] as num).toInt(),
      availability: (json['availability'] as List<dynamic>)
          .map((e) => Availability.fromJson(e as Map<String, dynamic>))
          .toList(),
      expectedHourlyRate: ExpectedHourlyRate.fromJson(
        json['expectedHourlyRate'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WorkerProfileToJson(WorkerProfile instance) =>
    <String, dynamic>{
      'education': instance.education,
      'professionalStatus': instance.professionalStatus,
      'pastExperience': instance.pastExperience,
      'jobsLookedFor': instance.jobsLookedFor,
      'experienceYears': instance.experienceYears,
      'availability': instance.availability.map((e) => e.toJson()).toList(),
      'expectedHourlyRate': instance.expectedHourlyRate.toJson(),
    };

Availability _$AvailabilityFromJson(Map<String, dynamic> json) => Availability(
  day: json['day'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
);

Map<String, dynamic> _$AvailabilityToJson(Availability instance) =>
    <String, dynamic>{
      'day': instance.day,
      'from': instance.from,
      'to': instance.to,
    };

ExpectedHourlyRate _$ExpectedHourlyRateFromJson(Map<String, dynamic> json) =>
    ExpectedHourlyRate(
      amount: json['amount'] as num,
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$ExpectedHourlyRateToJson(ExpectedHourlyRate instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};
