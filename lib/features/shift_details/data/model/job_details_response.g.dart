// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployerJobDetailsResponse _$EmployerJobDetailsResponseFromJson(
  Map<String, dynamic> json,
) => EmployerJobDetailsResponse(
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : JobDetailsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployerJobDetailsResponseToJson(
  EmployerJobDetailsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'data': instance.data?.toJson(),
};

JobDetailsData _$JobDetailsDataFromJson(Map<String, dynamic> json) =>
    JobDetailsData(
      job: json['job'] == null
          ? null
          : JobDetails.fromJson(json['job'] as Map<String, dynamic>),
      isFull: json['isFull'] as bool?,
      isOwner: json['isOwner'] as bool?,
      applications: (json['applications'] as List<dynamic>?)
          ?.map((e) => ApplicationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      myApplication: json['myApplication'] == null
          ? null
          : MyApplicationData.fromJson(
              json['myApplication'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$JobDetailsDataToJson(JobDetailsData instance) =>
    <String, dynamic>{
      'job': instance.job?.toJson(),
      'isFull': instance.isFull,
      'isOwner': instance.isOwner,
      'applications': instance.applications?.map((e) => e.toJson()).toList(),
      'myApplication': instance.myApplication?.toJson(),
    };

ApplicationData _$ApplicationDataFromJson(Map<String, dynamic> json) =>
    ApplicationData(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      workerId: json['workerId'] == null
          ? null
          : WorkerInfo.fromJson(json['workerId'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ApplicationDataToJson(ApplicationData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'workerId': instance.workerId?.toJson(),
      'createdAt': instance.createdAt,
    };

MyApplicationData _$MyApplicationDataFromJson(Map<String, dynamic> json) =>
    MyApplicationData(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$MyApplicationDataToJson(MyApplicationData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

WorkerInfo _$WorkerInfoFromJson(Map<String, dynamic> json) => WorkerInfo(
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  city: json['city'] as String?,
  imageProfile: json['imageProfile'] as String?,
  rating: json['rating'] as num?,
  ratingAverage: json['ratingAverage'] as num?,
);

Map<String, dynamic> _$WorkerInfoToJson(WorkerInfo instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'city': instance.city,
      'imageProfile': instance.imageProfile,
      'rating': instance.rating,
      'ratingAverage': instance.ratingAverage,
    };
