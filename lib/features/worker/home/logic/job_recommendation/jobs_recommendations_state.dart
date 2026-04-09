import 'package:freezed_annotation/freezed_annotation.dart';

part 'jobs_recommendations_state.freezed.dart';

@freezed
class JobsRecommendationsState<T> with _$JobsRecommendationsState<T> {
  const factory JobsRecommendationsState.initial() = _Initial;
  const factory JobsRecommendationsState.loading() = _Loading;
  const factory JobsRecommendationsState.success(T data) = _Success<T>;
  const factory JobsRecommendationsState.error({required String error}) = _Error;
}