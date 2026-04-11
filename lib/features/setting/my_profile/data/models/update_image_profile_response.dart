import 'package:json_annotation/json_annotation.dart';

part 'update_image_profile_response.g.dart';

@JsonSerializable()
class UpdateImageProfileResponse {
  final String? status;
  final String? message;
  final UpdateImageProfileData? data;

  UpdateImageProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateImageProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateImageProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateImageProfileResponseToJson(this);
}

@JsonSerializable()
class UpdateImageProfileData {
  final String? imageProfile;

  UpdateImageProfileData({this.imageProfile});

  factory UpdateImageProfileData.fromJson(Map<String, dynamic> json) =>
      _$UpdateImageProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateImageProfileDataToJson(this);
}