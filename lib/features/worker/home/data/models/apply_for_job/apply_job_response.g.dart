// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apply_job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplyJobResponse _$ApplyJobResponseFromJson(Map<String, dynamic> json) =>
    ApplyJobResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ApplyJobResponseToJson(ApplyJobResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
