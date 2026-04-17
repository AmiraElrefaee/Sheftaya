// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_applications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobApplicationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobApplicationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobApplicationsState()';
}


}

/// @nodoc
class $JobApplicationsStateCopyWith<$Res>  {
$JobApplicationsStateCopyWith(JobApplicationsState _, $Res Function(JobApplicationsState) __);
}


/// Adds pattern-matching-related methods to [JobApplicationsState].
extension JobApplicationsStatePatterns on JobApplicationsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( LoadingMore value)?  loadingMore,TResult Function( Accepting value)?  accepting,TResult Function( Success value)?  success,TResult Function( Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case LoadingMore() when loadingMore != null:
return loadingMore(_that);case Accepting() when accepting != null:
return accepting(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( LoadingMore value)  loadingMore,required TResult Function( Accepting value)  accepting,required TResult Function( Success value)  success,required TResult Function( Error value)  error,}){
final _that = this;
switch (_that) {
case Initial():
return initial(_that);case Loading():
return loading(_that);case LoadingMore():
return loadingMore(_that);case Accepting():
return accepting(_that);case Success():
return success(_that);case Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( LoadingMore value)?  loadingMore,TResult? Function( Accepting value)?  accepting,TResult? Function( Success value)?  success,TResult? Function( Error value)?  error,}){
final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case LoadingMore() when loadingMore != null:
return loadingMore(_that);case Accepting() when accepting != null:
return accepting(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( JobApplicationsResponse previous,  int nextPage)?  loadingMore,TResult Function( JobApplicationsResponse previous)?  accepting,TResult Function( JobApplicationsResponse data,  int page,  int limit,  String? status,  bool hasNextPage)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case LoadingMore() when loadingMore != null:
return loadingMore(_that.previous,_that.nextPage);case Accepting() when accepting != null:
return accepting(_that.previous);case Success() when success != null:
return success(_that.data,_that.page,_that.limit,_that.status,_that.hasNextPage);case Error() when error != null:
return error(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( JobApplicationsResponse previous,  int nextPage)  loadingMore,required TResult Function( JobApplicationsResponse previous)  accepting,required TResult Function( JobApplicationsResponse data,  int page,  int limit,  String? status,  bool hasNextPage)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case Initial():
return initial();case Loading():
return loading();case LoadingMore():
return loadingMore(_that.previous,_that.nextPage);case Accepting():
return accepting(_that.previous);case Success():
return success(_that.data,_that.page,_that.limit,_that.status,_that.hasNextPage);case Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( JobApplicationsResponse previous,  int nextPage)?  loadingMore,TResult? Function( JobApplicationsResponse previous)?  accepting,TResult? Function( JobApplicationsResponse data,  int page,  int limit,  String? status,  bool hasNextPage)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case LoadingMore() when loadingMore != null:
return loadingMore(_that.previous,_that.nextPage);case Accepting() when accepting != null:
return accepting(_that.previous);case Success() when success != null:
return success(_that.data,_that.page,_that.limit,_that.status,_that.hasNextPage);case Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class Initial implements JobApplicationsState {
  const Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobApplicationsState.initial()';
}


}




/// @nodoc


class Loading implements JobApplicationsState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobApplicationsState.loading()';
}


}




/// @nodoc


class LoadingMore implements JobApplicationsState {
  const LoadingMore({required this.previous, required this.nextPage});
  

 final  JobApplicationsResponse previous;
 final  int nextPage;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadingMoreCopyWith<LoadingMore> get copyWith => _$LoadingMoreCopyWithImpl<LoadingMore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingMore&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}


@override
int get hashCode => Object.hash(runtimeType,previous,nextPage);

@override
String toString() {
  return 'JobApplicationsState.loadingMore(previous: $previous, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class $LoadingMoreCopyWith<$Res> implements $JobApplicationsStateCopyWith<$Res> {
  factory $LoadingMoreCopyWith(LoadingMore value, $Res Function(LoadingMore) _then) = _$LoadingMoreCopyWithImpl;
@useResult
$Res call({
 JobApplicationsResponse previous, int nextPage
});




}
/// @nodoc
class _$LoadingMoreCopyWithImpl<$Res>
    implements $LoadingMoreCopyWith<$Res> {
  _$LoadingMoreCopyWithImpl(this._self, this._then);

  final LoadingMore _self;
  final $Res Function(LoadingMore) _then;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previous = null,Object? nextPage = null,}) {
  return _then(LoadingMore(
previous: null == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as JobApplicationsResponse,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class Accepting implements JobApplicationsState {
  const Accepting({required this.previous});
  

 final  JobApplicationsResponse previous;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcceptingCopyWith<Accepting> get copyWith => _$AcceptingCopyWithImpl<Accepting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Accepting&&(identical(other.previous, previous) || other.previous == previous));
}


@override
int get hashCode => Object.hash(runtimeType,previous);

@override
String toString() {
  return 'JobApplicationsState.accepting(previous: $previous)';
}


}

/// @nodoc
abstract mixin class $AcceptingCopyWith<$Res> implements $JobApplicationsStateCopyWith<$Res> {
  factory $AcceptingCopyWith(Accepting value, $Res Function(Accepting) _then) = _$AcceptingCopyWithImpl;
@useResult
$Res call({
 JobApplicationsResponse previous
});




}
/// @nodoc
class _$AcceptingCopyWithImpl<$Res>
    implements $AcceptingCopyWith<$Res> {
  _$AcceptingCopyWithImpl(this._self, this._then);

  final Accepting _self;
  final $Res Function(Accepting) _then;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previous = null,}) {
  return _then(Accepting(
previous: null == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as JobApplicationsResponse,
  ));
}


}

/// @nodoc


class Success implements JobApplicationsState {
  const Success({required this.data, required this.page, required this.limit, this.status, required this.hasNextPage});
  

 final  JobApplicationsResponse data;
 final  int page;
 final  int limit;
 final  String? status;
 final  bool hasNextPage;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&(identical(other.data, data) || other.data == data)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage));
}


@override
int get hashCode => Object.hash(runtimeType,data,page,limit,status,hasNextPage);

@override
String toString() {
  return 'JobApplicationsState.success(data: $data, page: $page, limit: $limit, status: $status, hasNextPage: $hasNextPage)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $JobApplicationsStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 JobApplicationsResponse data, int page, int limit, String? status, bool hasNextPage
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,Object? page = null,Object? limit = null,Object? status = freezed,Object? hasNextPage = null,}) {
  return _then(Success(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as JobApplicationsResponse,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class Error implements JobApplicationsState {
  const Error({required this.message});
  

 final  String message;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JobApplicationsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $JobApplicationsStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of JobApplicationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
