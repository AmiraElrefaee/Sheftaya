// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportResponse _$SupportResponseFromJson(Map<String, dynamic> json) =>
    SupportResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$SupportResponseToJson(SupportResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
