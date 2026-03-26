// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_jobs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenJobsResponse _$OpenJobsResponseFromJson(Map<String, dynamic> json) =>
    OpenJobsResponse(
      status: json['status'] as String?,
      results: (json['results'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OpenJobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OpenJobsResponseToJson(OpenJobsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'results': instance.results,
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

OpenJobModel _$OpenJobModelFromJson(Map<String, dynamic> json) => OpenJobModel(
  id: json['_id'] as String,
  location: json['location'] == null
      ? null
      : JobLocation.fromJson(json['location'] as Map<String, dynamic>),
  pricePerHour: json['pricePerHour'] == null
      ? null
      : PricePerHour.fromJson(json['pricePerHour'] as Map<String, dynamic>),
  payment: json['payment'] == null
      ? null
      : JobPayment.fromJson(json['payment'] as Map<String, dynamic>),
  confirmation: json['confirmation'] == null
      ? null
      : JobConfirmation.fromJson(json['confirmation'] as Map<String, dynamic>),
  cancellationPolicy: json['cancellationPolicy'] == null
      ? null
      : CancellationPolicy.fromJson(
          json['cancellationPolicy'] as Map<String, dynamic>,
        ),
  employerId: json['employerId'] as String?,
  title: json['title'] as String?,
  place: json['place'] as String?,
  startDateTime: json['startDateTime'] as String?,
  endDateTime: json['endDateTime'] as String?,
  dailyWorkHours: (json['dailyWorkHours'] as num?)?.toInt(),
  requiredWorkers: (json['requiredWorkers'] as num?)?.toInt(),
  acceptedWorkersCount: (json['acceptedWorkersCount'] as num?)?.toInt(),
  experienceLevel: json['experienceLevel'] as String?,
  details: json['details'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$OpenJobModelToJson(OpenJobModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'location': instance.location?.toJson(),
      'pricePerHour': instance.pricePerHour?.toJson(),
      'payment': instance.payment?.toJson(),
      'confirmation': instance.confirmation?.toJson(),
      'cancellationPolicy': instance.cancellationPolicy?.toJson(),
      'employerId': instance.employerId,
      'title': instance.title,
      'place': instance.place,
      'startDateTime': instance.startDateTime,
      'endDateTime': instance.endDateTime,
      'dailyWorkHours': instance.dailyWorkHours,
      'requiredWorkers': instance.requiredWorkers,
      'acceptedWorkersCount': instance.acceptedWorkersCount,
      'experienceLevel': instance.experienceLevel,
      'details': instance.details,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
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

JobPayment _$JobPaymentFromJson(Map<String, dynamic> json) => JobPayment(
  method: json['method'] as String?,
  status: json['status'] as String?,
  totalAmount: json['totalAmount'] as num?,
  platformFee: json['platformFee'] as num?,
);

Map<String, dynamic> _$JobPaymentToJson(JobPayment instance) =>
    <String, dynamic>{
      'method': instance.method,
      'status': instance.status,
      'totalAmount': instance.totalAmount,
      'platformFee': instance.platformFee,
    };

JobConfirmation _$JobConfirmationFromJson(Map<String, dynamic> json) =>
    JobConfirmation(
      employerConfirmed: json['employerConfirmed'] as bool?,
      workersConfirmedCount: (json['workersConfirmedCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JobConfirmationToJson(JobConfirmation instance) =>
    <String, dynamic>{
      'employerConfirmed': instance.employerConfirmed,
      'workersConfirmedCount': instance.workersConfirmedCount,
    };

CancellationPolicy _$CancellationPolicyFromJson(Map<String, dynamic> json) =>
    CancellationPolicy(
      freeCancelUntil: json['freeCancelUntil'] as String?,
      penaltyAfter: json['penaltyAfter'] as String?,
    );

Map<String, dynamic> _$CancellationPolicyToJson(CancellationPolicy instance) =>
    <String, dynamic>{
      'freeCancelUntil': instance.freeCancelUntil,
      'penaltyAfter': instance.penaltyAfter,
    };
