import 'package:json_annotation/json_annotation.dart';

part 'job_recommendation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class JobRecommendationResponse {
  final String? status;
  final int? results;
  final List<JobRecommendationModel>? data;

  JobRecommendationResponse({this.status, this.results, this.data});

  factory JobRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JobRecommendationResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobRecommendationModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final RecommendationLocation? location;
  final RecommendationPricePerHour? pricePerHour;
  final String? experienceLevel;
  final String? details;

  JobRecommendationModel({
    this.id,
    this.title,
    this.location,
    this.pricePerHour,
    this.experienceLevel,
    this.details,
  });

  factory JobRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobRecommendationModelToJson(this);
}

@JsonSerializable()
class RecommendationLocation {
  final String? type;
  final List<num>? coordinates;
  final String? mainPlace;
  final String? address;

  RecommendationLocation({
    this.type,
    this.coordinates,
    this.mainPlace,
    this.address,
  });

  factory RecommendationLocation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationLocationFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationLocationToJson(this);
}

@JsonSerializable()
class RecommendationPricePerHour {
  final num? amount;
  final String? currency;

  RecommendationPricePerHour({this.amount, this.currency});

  factory RecommendationPricePerHour.fromJson(Map<String, dynamic> json) =>
      _$RecommendationPricePerHourFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationPricePerHourToJson(this);
}
