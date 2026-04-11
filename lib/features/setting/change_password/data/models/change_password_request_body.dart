import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_body.g.dart';

@JsonSerializable()
class ChangePasswordRequestBody {
  final String currentPassword;
  final String newPassword;
  final String passwordConfirm;

  ChangePasswordRequestBody({
    required this.currentPassword,
    required this.newPassword,
    required this.passwordConfirm,
  });

  factory ChangePasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestBodyToJson(this);
}