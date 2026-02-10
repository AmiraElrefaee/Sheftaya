// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_signup_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifySignupRequestBody _$VerifySignupRequestBodyFromJson(
  Map<String, dynamic> json,
) => VerifySignupRequestBody(
  email: json['email'] as String,
  code: json['code'] as String,
);

Map<String, dynamic> _$VerifySignupRequestBodyToJson(
  VerifySignupRequestBody instance,
) => <String, dynamic>{'email': instance.email, 'code': instance.code};
