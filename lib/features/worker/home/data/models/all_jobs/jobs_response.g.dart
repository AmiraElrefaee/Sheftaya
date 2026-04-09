// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobsResponse _$JobsResponseFromJson(Map<String, dynamic> json) => JobsResponse(
  status: json['status'] as String?,
  page: (json['page'] as num?)?.toInt(),
  results: (json['results'] as num?)?.toInt(),
  totalResults: (json['totalResults'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  hasNextPage: json['hasNextPage'] as bool?,
  hasPrevPage: json['hasPrevPage'] as bool?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => JobItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JobsResponseToJson(JobsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'page': instance.page,
      'results': instance.results,
      'totalResults': instance.totalResults,
      'totalPages': instance.totalPages,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

JobItem _$JobItemFromJson(Map<String, dynamic> json) => JobItem(
  id: json['_id'] as String?,
  title: json['title'] as String?,
  requiredSkills: (json['requiredSkills'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  jobImages: (json['JobImages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  place: json['place'] as String?,
  location: json['location'] == null
      ? null
      : JobLocation.fromJson(json['location'] as Map<String, dynamic>),
  startDateTime: json['startDateTime'] as String?,
  endDateTime: json['endDateTime'] as String?,
  dailyWorkHours: (json['dailyWorkHours'] as num?)?.toInt(),
  requiredWorkers: (json['requiredWorkers'] as num?)?.toInt(),
  acceptedWorkersCount: (json['acceptedWorkersCount'] as num?)?.toInt(),
  pricePerHour: json['pricePerHour'] == null
      ? null
      : PricePerHour.fromJson(json['pricePerHour'] as Map<String, dynamic>),
  experienceLevel: json['experienceLevel'] as String?,
  status: json['status'] as String?,
  details: json['details'] as String?,
  employerId: json['employerId'] == null
      ? null
      : JobEmployerId.fromJson(json['employerId'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$JobItemToJson(JobItem instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'requiredSkills': instance.requiredSkills,
  'JobImages': instance.jobImages,
  'place': instance.place,
  'location': instance.location?.toJson(),
  'startDateTime': instance.startDateTime,
  'endDateTime': instance.endDateTime,
  'dailyWorkHours': instance.dailyWorkHours,
  'requiredWorkers': instance.requiredWorkers,
  'acceptedWorkersCount': instance.acceptedWorkersCount,
  'pricePerHour': instance.pricePerHour?.toJson(),
  'experienceLevel': instance.experienceLevel,
  'status': instance.status,
  'details': instance.details,
  'employerId': instance.employerId?.toJson(),
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

JobEmployerId _$JobEmployerIdFromJson(Map<String, dynamic> json) =>
    JobEmployerId(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$JobEmployerIdToJson(JobEmployerId instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

JobLocation _$JobLocationFromJson(Map<String, dynamic> json) => JobLocation(
  type: json['type'] as String?,
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => e as num)
      .toList(),
  mainPlace: json['mainPlace'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$JobLocationToJson(JobLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
      'mainPlace': instance.mainPlace,
      'address': instance.address,
    };

PricePerHour _$PricePerHourFromJson(Map<String, dynamic> json) => PricePerHour(
  amount: json['amount'] as num?,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$PricePerHourToJson(PricePerHour instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};

WorkerJobDetailsResponse _$WorkerJobDetailsResponseFromJson(
  Map<String, dynamic> json,
) => WorkerJobDetailsResponse(
  status: json['status'] as String?,
  data: json['data'] == null
      ? null
      : WorkerJobDetailsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WorkerJobDetailsResponseToJson(
  WorkerJobDetailsResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'data': instance.data?.toJson(),
};

WorkerJobDetailsData _$WorkerJobDetailsDataFromJson(
  Map<String, dynamic> json,
) => WorkerJobDetailsData(
  job: json['job'] == null
      ? null
      : JobItem.fromJson(json['job'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WorkerJobDetailsDataToJson(
  WorkerJobDetailsData instance,
) => <String, dynamic>{'job': instance.job?.toJson()};
