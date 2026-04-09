part of 'job_details_cubit.dart';

@freezed
class JobDetailsState with _$JobDetailsState {
  const factory JobDetailsState.initial() = _Initial;
  const factory JobDetailsState.loading() = _Loading;
  const factory JobDetailsState.success({required JobItem data}) = _Success; // ✅ JobItem
  const factory JobDetailsState.error({required String message}) = _Error;
}