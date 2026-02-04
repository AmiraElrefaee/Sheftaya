import 'package:json_annotation/json_annotation.dart';

part 'verify_password_request_body.g.dart';

@JsonSerializable()
class VerifyPasswordRequestBody {
  final String email;

  @JsonKey(name: 'code')
  final String code;

  VerifyPasswordRequestBody({required this.email, required this.code});

  Map<String, dynamic> toJson() => _$VerifyPasswordRequestBodyToJson(this);

  factory VerifyPasswordRequestBody.fromJson(Map<String, dynamic> json) =>
      _$VerifyPasswordRequestBodyFromJson(json);
}
