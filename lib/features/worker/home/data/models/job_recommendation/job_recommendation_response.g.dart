// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_recommendation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRecommendationResponse _$JobRecommendationResponseFromJson(
  Map<String, dynamic> json,
) => JobRecommendationResponse(
  status: json['status'] as String?,
  results: (json['results'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => JobRecommendationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JobRecommendationResponseToJson(
  JobRecommendationResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'results': instance.results,
  'data': instance.data?.map((e) => e.toJson()).toList(),
};

JobRecommendationModel _$JobRecommendationModelFromJson(
  Map<String, dynamic> json,
) => JobRecommendationModel(
  id: json['_id'] as String?,
  title: json['title'] as String?,
  location: json['location'] == null
      ? null
      : RecommendationLocation.fromJson(
          json['location'] as Map<String, dynamic>,
        ),
  pricePerHour: json['pricePerHour'] == null
      ? null
      : RecommendationPricePerHour.fromJson(
          json['pricePerHour'] as Map<String, dynamic>,
        ),
  experienceLevel: json['experienceLevel'] as String?,
  details: json['details'] as String?,
);

Map<String, dynamic> _$JobRecommendationModelToJson(
  JobRecommendationModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'location': instance.location?.toJson(),
  'pricePerHour': instance.pricePerHour?.toJson(),
  'experienceLevel': instance.experienceLevel,
  'details': instance.details,
};

RecommendationLocation _$RecommendationLocationFromJson(
  Map<String, dynamic> json,
) => RecommendationLocation(
  type: json['type'] as String?,
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => e as num)
      .toList(),
  mainPlace: json['mainPlace'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$RecommendationLocationToJson(
  RecommendationLocation instance,
) => <String, dynamic>{
  'type': instance.type,
  'coordinates': instance.coordinates,
  'mainPlace': instance.mainPlace,
  'address': instance.address,
};

RecommendationPricePerHour _$RecommendationPricePerHourFromJson(
  Map<String, dynamic> json,
) => RecommendationPricePerHour(
  amount: json['amount'] as num?,
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$RecommendationPricePerHourToJson(
  RecommendationPricePerHour instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
};
