import 'package:json_annotation/json_annotation.dart';

part 'forget_pass_response.g.dart';

@JsonSerializable()
class ForgetPassResponse {
  final String? status;
  final String? message;

  ForgetPassResponse({this.status, this.message});

  factory ForgetPassResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgetPassResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgetPassResponseToJson(this);
}
