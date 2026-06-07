// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyJobsResponse _$MyJobsResponseFromJson(Map<String, dynamic> json) =>
    MyJobsResponse(
      status: json['status'] as String?,
      results: (json['results'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyJobItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyJobsResponseToJson(MyJobsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'results': instance.results,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

MyJobItem _$MyJobItemFromJson(Map<String, dynamic> json) => MyJobItem(
  id: json['_id'] as String?,
  title: json['title'] as String?,
  place: json['place'] as String?,
  postedAt: json['postedAt'] as String?,
  finalStatus: json['finalStatus'] as String?,
  jobStatus: json['jobStatus'] as String?,
  job: json['job'] == null
      ? null
      : JobDetails.fromJson(json['job'] as Map<String, dynamic>),
  applicationStatus: json['applicationStatus'] as String?,
  arrivalStatus: json['arrivalStatus'] as String?,
  appliedAt: json['appliedAt'] as String?,
  applicationId: json['applicationId'] as String?,
);

Map<String, dynamic> _$MyJobItemToJson(MyJobItem instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'place': instance.place,
  'postedAt': instance.postedAt,
  'finalStatus': instance.finalStatus,
  'jobStatus': instance.jobStatus,
  'job': instance.job?.toJson(),
  'applicationStatus': instance.applicationStatus,
  'arrivalStatus': instance.arrivalStatus,
  'appliedAt': instance.appliedAt,
  'applicationId': instance.applicationId,
};

JobDetails _$JobDetailsFromJson(Map<String, dynamic> json) => JobDetails(
  id: json['_id'] as String?,
  title: json['title'] as String?,
  jobImages: (json['jobImages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  place: json['place'] as String?,
  location: json['location'] == null
      ? null
      : JobLocation.fromJson(json['location'] as Map<String, dynamic>),
  startDateTime: json['startDateTime'] as String?,
  dailyWorkHours: (json['dailyWorkHours'] as num?)?.toInt(),
  requiredWorkers: (json['requiredWorkers'] as num?)?.toInt(),
  acceptedWorkersCount: (json['acceptedWorkersCount'] as num?)?.toInt(),
  pricePerHour: json['pricePerHour'] == null
      ? null
      : PricePerHour.fromJson(json['pricePerHour'] as Map<String, dynamic>),
  details: json['details'] as String?,
  companyDetails: json['companyDetails'] == null
      ? null
      : CompanyDetails.fromJson(json['companyDetails'] as Map<String, dynamic>),
  status: json['status'] as String?,
  payment: json['payment'] == null
      ? null
      : PaymentDetails.fromJson(json['payment'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$JobDetailsToJson(JobDetails instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'jobImages': instance.jobImages,
      'place': instance.place,
      'location': instance.location?.toJson(),
      'startDateTime': instance.startDateTime,
      'dailyWorkHours': instance.dailyWorkHours,
      'requiredWorkers': instance.requiredWorkers,
      'acceptedWorkersCount': instance.acceptedWorkersCount,
      'pricePerHour': instance.pricePerHour?.toJson(),
      'details': instance.details,
      'companyDetails': instance.companyDetails?.toJson(),
      'status': instance.status,
      'payment': instance.payment?.toJson(),
      'createdAt': instance.createdAt,
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

CompanyDetails _$CompanyDetailsFromJson(Map<String, dynamic> json) =>
    CompanyDetails(
      companyName: json['companyName'] as String?,
      companyType: json['companyType'] as String?,
      companyAddress: json['companyAddress'] as String?,
      companyCity: json['companyCity'] as String?,
      companyContactPersonName: json['companyContactPersonName'] as String?,
      companyImages: (json['companyImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CompanyDetailsToJson(CompanyDetails instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'companyType': instance.companyType,
      'companyAddress': instance.companyAddress,
      'companyCity': instance.companyCity,
      'companyContactPersonName': instance.companyContactPersonName,
      'companyImages': instance.companyImages,
    };

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      method: json['method'] as String?,
      status: json['status'] as String?,
      totalAmount: json['totalAmount'] as num?,
      platformFee: json['platformFee'] as num?,
    );

Map<String, dynamic> _$PaymentDetailsToJson(PaymentDetails instance) =>
    <String, dynamic>{
      'method': instance.method,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'platformFee': instance.platformFee,
    };
