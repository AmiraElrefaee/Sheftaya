// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_worker_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptWorkerResponse _$AcceptWorkerResponseFromJson(
  Map<String, dynamic> json,
) => AcceptWorkerResponse(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : AcceptedWorkerData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AcceptWorkerResponseToJson(
  AcceptWorkerResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

AcceptedWorkerData _$AcceptedWorkerDataFromJson(Map<String, dynamic> json) =>
    AcceptedWorkerData(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      acceptedByEmployerAt: json['acceptedByEmployerAt'] as String?,
      employerAccepted: json['employerAccepted'] as bool?,
    );

Map<String, dynamic> _$AcceptedWorkerDataToJson(AcceptedWorkerData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'status': instance.status,
      'acceptedByEmployerAt': instance.acceptedByEmployerAt,
      'employerAccepted': instance.employerAccepted,
    };
