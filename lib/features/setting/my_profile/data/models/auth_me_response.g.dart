// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthMeResponse _$AuthMeResponseFromJson(Map<String, dynamic> json) =>
    AuthMeResponse(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : AuthMeData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthMeResponseToJson(AuthMeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data?.toJson(),
    };

AuthMeData _$AuthMeDataFromJson(Map<String, dynamic> json) => AuthMeData(
  user: json['user'] == null
      ? null
      : AuthMeUser.fromJson(json['user'] as Map<String, dynamic>),
  workerProfile: json['workerProfile'] == null
      ? null
      : WorkerProfile.fromJson(json['workerProfile'] as Map<String, dynamic>),
  profile: json['profile'] == null
      ? null
      : EmployerProfile.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthMeDataToJson(AuthMeData instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
      'workerProfile': instance.workerProfile?.toJson(),
      'profile': instance.profile?.toJson(),
    };

AuthMeUser _$AuthMeUserFromJson(Map<String, dynamic> json) => AuthMeUser(
  discipline: json['discipline'] == null
      ? null
      : Discipline.fromJson(json['discipline'] as Map<String, dynamic>),
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  preferredLang: json['preferredLang'] as String?,
  city: json['city'] as String?,
  status: json['status'] as String?,
  fcmTokens: json['fcmTokens'] as List<dynamic>?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
  v: (json['v'] as num?)?.toInt(),
  imageProfile: json['imageProfile'] as String?,
  birthday: json['birthday'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  ratingAverage: (json['ratingAverage'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AuthMeUserToJson(AuthMeUser instance) =>
    <String, dynamic>{
      'discipline': instance.discipline?.toJson(),
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'role': instance.role,
      'preferredLang': instance.preferredLang,
      'city': instance.city,
      'status': instance.status,
      'fcmTokens': instance.fcmTokens,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'v': instance.v,
      'imageProfile': instance.imageProfile,
      'birthday': instance.birthday,
      'rating': instance.rating,
      'ratingAverage': instance.ratingAverage,
    };

Discipline _$DisciplineFromJson(Map<String, dynamic> json) => Discipline(
  warnings: (json['warnings'] as num?)?.toInt(),
  cancellations: (json['cancellations'] as num?)?.toInt(),
  noShows: (json['noShows'] as num?)?.toInt(),
);

Map<String, dynamic> _$DisciplineToJson(Discipline instance) =>
    <String, dynamic>{
      'warnings': instance.warnings,
      'cancellations': instance.cancellations,
      'noShows': instance.noShows,
    };

WorkerProfile _$WorkerProfileFromJson(Map<String, dynamic> json) =>
    WorkerProfile(
      expectedHourlyRate: json['expectedHourlyRate'] == null
          ? null
          : ExpectedHourlyRate.fromJson(
              json['expectedHourlyRate'] as Map<String, dynamic>,
            ),
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      education: json['education'] as String?,
      professionalStatus: json['professionalStatus'] as String?,
      pastExperience: (json['pastExperience'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      jobsLookedFor: (json['jobsLookedFor'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      healthCertificate: json['healthCertificate'] as String?,
      availability: json['availability'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkerProfileToJson(WorkerProfile instance) =>
    <String, dynamic>{
      'expectedHourlyRate': instance.expectedHourlyRate?.toJson(),
      '_id': instance.id,
      'userId': instance.userId,
      'education': instance.education,
      'professionalStatus': instance.professionalStatus,
      'pastExperience': instance.pastExperience,
      'jobsLookedFor': instance.jobsLookedFor,
      'experienceYears': instance.experienceYears,
      'healthCertificate': instance.healthCertificate,
      'availability': instance.availability,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'v': instance.v,
    };

ExpectedHourlyRate _$ExpectedHourlyRateFromJson(Map<String, dynamic> json) =>
    ExpectedHourlyRate(
      amount: json['amount'] as num?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$ExpectedHourlyRateToJson(ExpectedHourlyRate instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};

EmployerProfile _$EmployerProfileFromJson(Map<String, dynamic> json) =>
    EmployerProfile(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      companyName: json['companyName'] as String?,
      companyType: json['companyType'] as String?,
      companyAddress: json['companyAddress'] as String?,
      city: json['city'] as String?,
      companyImages: (json['companyImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: (json['v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployerProfileToJson(EmployerProfile instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'companyName': instance.companyName,
      'companyType': instance.companyType,
      'companyAddress': instance.companyAddress,
      'city': instance.city,
      'companyImages': instance.companyImages,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'v': instance.v,
    };
