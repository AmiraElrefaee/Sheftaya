import 'package:json_annotation/json_annotation.dart';

part 'apply_job_response.g.dart';

@JsonSerializable()
class ApplyJobResponse {
  final String? status;
  final String? message;
  final Map<String, dynamic>? data;

  ApplyJobResponse({this.status, this.message, this.data});

  factory ApplyJobResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyJobResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyJobResponseToJson(this);
}
