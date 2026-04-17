import 'package:json_annotation/json_annotation.dart';

part 'accept_worker_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AcceptWorkerResponse {
  final String? status;
  final String? message;
  final AcceptedWorkerData? data;

  AcceptWorkerResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AcceptWorkerResponse.fromJson(Map<String, dynamic> json) =>
      _$AcceptWorkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptWorkerResponseToJson(this);
}

@JsonSerializable()
class AcceptedWorkerData {
  @JsonKey(name: '_id')
  final String? id;
  final String? status;
  final String? acceptedByEmployerAt;
  final bool? employerAccepted;

  AcceptedWorkerData({
    this.id,
    this.status,
    this.acceptedByEmployerAt,
    this.employerAccepted,
  });

  factory AcceptedWorkerData.fromJson(Map<String, dynamic> json) =>
      _$AcceptedWorkerDataFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptedWorkerDataToJson(this);
}