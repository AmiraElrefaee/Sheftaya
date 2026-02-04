// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_new_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateNewPasswordRequestBody _$CreateNewPasswordRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateNewPasswordRequestBody(
  email: json['email'] as String,
  newPassword: json['newPassword'] as String,
  passwordConfirm: json['passwordConfirm'] as String,
);

Map<String, dynamic> _$CreateNewPasswordRequestBodyToJson(
  CreateNewPasswordRequestBody instance,
) => <String, dynamic>{
  'email': instance.email,
  'newPassword': instance.newPassword,
  'passwordConfirm': instance.passwordConfirm,
};
