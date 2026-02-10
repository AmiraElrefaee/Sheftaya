import 'package:json_annotation/json_annotation.dart';

part 'verify_signup_request_body.g.dart';
@JsonSerializable()
class VerifySignupRequestBody {
  final String email;
  final String code;

  VerifySignupRequestBody({
    required this.email,
    required this.code,
  });

  factory VerifySignupRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerifySignupRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifySignupRequestBodyToJson(this);
}
