// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_applications_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobApplicationsResponse _$JobApplicationsResponseFromJson(
  Map<String, dynamic> json,
) => JobApplicationsResponse(
  status: json['status'] as String?,
  page: (json['page'] as num?)?.toInt(),
  results: (json['results'] as num?)?.toInt(),
  totalResults: (json['totalResults'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  hasNextPage: json['hasNextPage'] as bool?,
  hasPrevPage: json['hasPrevPage'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => JobApplicationItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JobApplicationsResponseToJson(
  JobApplicationsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'page': instance.page,
  'results': instance.results,
  'totalResults': instance.totalResults,
  'totalPages': instance.totalPages,
  'hasNextPage': instance.hasNextPage,
  'hasPrevPage': instance.hasPrevPage,
  'data': instance.data?.map((e) => e.toJson()).toList(),
};

JobApplicationItem _$JobApplicationItemFromJson(Map<String, dynamic> json) =>
    JobApplicationItem(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      arrivalStatus: json['arrivalStatus'] as String?,
      createdAt: json['createdAt'] as String?,
      workerId: json['workerId'] == null
          ? null
          : WorkerBasicInfo.fromJson(json['workerId'] as Map<String, dynamic>),
      workerProfile: json['workerProfile'] == null
          ? null
          : WorkerProfileInfo.fromJson(
              json['workerProfile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$JobApplicationItemToJson(JobApplicationItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'arrivalStatus': instance.arrivalStatus,
      'createdAt': instance.createdAt,
      'workerId': instance.workerId?.toJson(),
      'workerProfile': instance.workerProfile?.toJson(),
    };

WorkerBasicInfo _$WorkerBasicInfoFromJson(Map<String, dynamic> json) =>
    WorkerBasicInfo(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      city: json['city'] as String?,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$WorkerBasicInfoToJson(WorkerBasicInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'city': instance.city,
      'profileImage': instance.profileImage,
    };

WorkerProfileInfo _$WorkerProfileInfoFromJson(Map<String, dynamic> json) =>
    WorkerProfileInfo(
      userId: json['userId'] as String?,
      pastExperience: json['pastExperience'],
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      expectedHourlyRate: json['expectedHourlyRate'],
    );

Map<String, dynamic> _$WorkerProfileInfoToJson(WorkerProfileInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pastExperience': instance.pastExperience,
      'experienceYears': instance.experienceYears,
      'expectedHourlyRate': instance.expectedHourlyRate,
    };
