// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_signup_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$VerifySignupResponseToJson(
  VerifySignupResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'token': instance.token,
  'user': instance.user,
};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['_id'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  imageProfile: json['imageProfile'] as String?,
  phone: json['phone'] as String?,
  status: json['status'] as String?,
  preferredLang: json['preferredLang'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'role': instance.role,
  'imageProfile': instance.imageProfile,
  'phone': instance.phone,
  'status': instance.status,
  'preferredLang': instance.preferredLang,
};
