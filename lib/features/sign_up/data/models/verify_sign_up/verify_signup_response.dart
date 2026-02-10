import 'package:json_annotation/json_annotation.dart';

part 'verify_signup_response.g.dart';
@JsonSerializable()
class VerifySignupResponse {
  final String? status;
  final String? message;
  final String? token;
  final UserData? user;

  VerifySignupResponse({this.status, this.message, this.token, this.user});

  factory VerifySignupResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifySignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifySignupResponseToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: '_id')
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final String? imageProfile;
  final String? phone;
  final String? status;
  final String? preferredLang;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.imageProfile,
    this.phone,
    this.status,
    this.preferredLang,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
