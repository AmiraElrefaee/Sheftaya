import 'package:json_annotation/json_annotation.dart';

part 'support_response.g.dart';

@JsonSerializable()
class SupportResponse {
  final String? status;
  final String? message;
  final dynamic data;

  SupportResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SupportResponse.fromJson(Map<String, dynamic> json) =>
      _$SupportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SupportResponseToJson(this);
}