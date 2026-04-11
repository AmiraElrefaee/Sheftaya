// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_image_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateImageProfileResponse _$UpdateImageProfileResponseFromJson(
  Map<String, dynamic> json,
) => UpdateImageProfileResponse(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : UpdateImageProfileData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateImageProfileResponseToJson(
  UpdateImageProfileResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

UpdateImageProfileData _$UpdateImageProfileDataFromJson(
  Map<String, dynamic> json,
) => UpdateImageProfileData(imageProfile: json['imageProfile'] as String?);

Map<String, dynamic> _$UpdateImageProfileDataToJson(
  UpdateImageProfileData instance,
) => <String, dynamic>{'imageProfile': instance.imageProfile};
