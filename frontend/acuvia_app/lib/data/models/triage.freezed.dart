// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'triage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriageRequest {

 List<String> get symptoms;@JsonKey(name: 'free_text') String get freeText; int get age; String get sex; List<String> get conditions;
/// Create a copy of TriageRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriageRequestCopyWith<TriageRequest> get copyWith => _$TriageRequestCopyWithImpl<TriageRequest>(this as TriageRequest, _$identity);

  /// Serializes this TriageRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriageRequest&&const DeepCollectionEquality().equals(other.symptoms, symptoms)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&(identical(other.age, age) || other.age == age)&&(identical(other.sex, sex) || other.sex == sex)&&const DeepCollectionEquality().equals(other.conditions, conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(symptoms),freeText,age,sex,const DeepCollectionEquality().hash(conditions));

@override
String toString() {
  return 'TriageRequest(symptoms: $symptoms, freeText: $freeText, age: $age, sex: $sex, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class $TriageRequestCopyWith<$Res>  {
  factory $TriageRequestCopyWith(TriageRequest value, $Res Function(TriageRequest) _then) = _$TriageRequestCopyWithImpl;
@useResult
$Res call({
 List<String> symptoms,@JsonKey(name: 'free_text') String freeText, int age, String sex, List<String> conditions
});




}
/// @nodoc
class _$TriageRequestCopyWithImpl<$Res>
    implements $TriageRequestCopyWith<$Res> {
  _$TriageRequestCopyWithImpl(this._self, this._then);

  final TriageRequest _self;
  final $Res Function(TriageRequest) _then;

/// Create a copy of TriageRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symptoms = null,Object? freeText = null,Object? age = null,Object? sex = null,Object? conditions = null,}) {
  return _then(_self.copyWith(
symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: null == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TriageRequest].
extension TriageRequestPatterns on TriageRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriageRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriageRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriageRequest value)  $default,){
final _that = this;
switch (_that) {
case _TriageRequest():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriageRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TriageRequest() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> symptoms, @JsonKey(name: 'free_text')  String freeText,  int age,  String sex,  List<String> conditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriageRequest() when $default != null:
return $default(_that.symptoms,_that.freeText,_that.age,_that.sex,_that.conditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> symptoms, @JsonKey(name: 'free_text')  String freeText,  int age,  String sex,  List<String> conditions)  $default,) {final _that = this;
switch (_that) {
case _TriageRequest():
return $default(_that.symptoms,_that.freeText,_that.age,_that.sex,_that.conditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> symptoms, @JsonKey(name: 'free_text')  String freeText,  int age,  String sex,  List<String> conditions)?  $default,) {final _that = this;
switch (_that) {
case _TriageRequest() when $default != null:
return $default(_that.symptoms,_that.freeText,_that.age,_that.sex,_that.conditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriageRequest implements TriageRequest {
  const _TriageRequest({required final  List<String> symptoms, @JsonKey(name: 'free_text') this.freeText = '', required this.age, required this.sex, final  List<String> conditions = const []}): _symptoms = symptoms,_conditions = conditions;
  factory _TriageRequest.fromJson(Map<String, dynamic> json) => _$TriageRequestFromJson(json);

 final  List<String> _symptoms;
@override List<String> get symptoms {
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symptoms);
}

@override@JsonKey(name: 'free_text') final  String freeText;
@override final  int age;
@override final  String sex;
 final  List<String> _conditions;
@override@JsonKey() List<String> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}


/// Create a copy of TriageRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageRequestCopyWith<_TriageRequest> get copyWith => __$TriageRequestCopyWithImpl<_TriageRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriageRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriageRequest&&const DeepCollectionEquality().equals(other._symptoms, _symptoms)&&(identical(other.freeText, freeText) || other.freeText == freeText)&&(identical(other.age, age) || other.age == age)&&(identical(other.sex, sex) || other.sex == sex)&&const DeepCollectionEquality().equals(other._conditions, _conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_symptoms),freeText,age,sex,const DeepCollectionEquality().hash(_conditions));

@override
String toString() {
  return 'TriageRequest(symptoms: $symptoms, freeText: $freeText, age: $age, sex: $sex, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class _$TriageRequestCopyWith<$Res> implements $TriageRequestCopyWith<$Res> {
  factory _$TriageRequestCopyWith(_TriageRequest value, $Res Function(_TriageRequest) _then) = __$TriageRequestCopyWithImpl;
@override @useResult
$Res call({
 List<String> symptoms,@JsonKey(name: 'free_text') String freeText, int age, String sex, List<String> conditions
});




}
/// @nodoc
class __$TriageRequestCopyWithImpl<$Res>
    implements _$TriageRequestCopyWith<$Res> {
  __$TriageRequestCopyWithImpl(this._self, this._then);

  final _TriageRequest _self;
  final $Res Function(_TriageRequest) _then;

/// Create a copy of TriageRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symptoms = null,Object? freeText = null,Object? age = null,Object? sex = null,Object? conditions = null,}) {
  return _then(_TriageRequest(
symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>,freeText: null == freeText ? _self.freeText : freeText // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,sex: null == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TriageResult {

 String get priority; String? get tagline; String? get reason;@JsonKey(name: 'next_steps') List<String> get nextSteps;@JsonKey(name: 'assessment_id') int get assessmentId;
/// Create a copy of TriageResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriageResultCopyWith<TriageResult> get copyWith => _$TriageResultCopyWithImpl<TriageResult>(this as TriageResult, _$identity);

  /// Serializes this TriageResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriageResult&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.nextSteps, nextSteps)&&(identical(other.assessmentId, assessmentId) || other.assessmentId == assessmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priority,tagline,reason,const DeepCollectionEquality().hash(nextSteps),assessmentId);

@override
String toString() {
  return 'TriageResult(priority: $priority, tagline: $tagline, reason: $reason, nextSteps: $nextSteps, assessmentId: $assessmentId)';
}


}

/// @nodoc
abstract mixin class $TriageResultCopyWith<$Res>  {
  factory $TriageResultCopyWith(TriageResult value, $Res Function(TriageResult) _then) = _$TriageResultCopyWithImpl;
@useResult
$Res call({
 String priority, String? tagline, String? reason,@JsonKey(name: 'next_steps') List<String> nextSteps,@JsonKey(name: 'assessment_id') int assessmentId
});




}
/// @nodoc
class _$TriageResultCopyWithImpl<$Res>
    implements $TriageResultCopyWith<$Res> {
  _$TriageResultCopyWithImpl(this._self, this._then);

  final TriageResult _self;
  final $Res Function(TriageResult) _then;

/// Create a copy of TriageResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priority = null,Object? tagline = freezed,Object? reason = freezed,Object? nextSteps = null,Object? assessmentId = null,}) {
  return _then(_self.copyWith(
priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,nextSteps: null == nextSteps ? _self.nextSteps : nextSteps // ignore: cast_nullable_to_non_nullable
as List<String>,assessmentId: null == assessmentId ? _self.assessmentId : assessmentId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TriageResult].
extension TriageResultPatterns on TriageResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriageResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriageResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriageResult value)  $default,){
final _that = this;
switch (_that) {
case _TriageResult():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriageResult value)?  $default,){
final _that = this;
switch (_that) {
case _TriageResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String priority,  String? tagline,  String? reason, @JsonKey(name: 'next_steps')  List<String> nextSteps, @JsonKey(name: 'assessment_id')  int assessmentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriageResult() when $default != null:
return $default(_that.priority,_that.tagline,_that.reason,_that.nextSteps,_that.assessmentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String priority,  String? tagline,  String? reason, @JsonKey(name: 'next_steps')  List<String> nextSteps, @JsonKey(name: 'assessment_id')  int assessmentId)  $default,) {final _that = this;
switch (_that) {
case _TriageResult():
return $default(_that.priority,_that.tagline,_that.reason,_that.nextSteps,_that.assessmentId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String priority,  String? tagline,  String? reason, @JsonKey(name: 'next_steps')  List<String> nextSteps, @JsonKey(name: 'assessment_id')  int assessmentId)?  $default,) {final _that = this;
switch (_that) {
case _TriageResult() when $default != null:
return $default(_that.priority,_that.tagline,_that.reason,_that.nextSteps,_that.assessmentId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriageResult implements TriageResult {
  const _TriageResult({required this.priority, this.tagline, this.reason, @JsonKey(name: 'next_steps') final  List<String> nextSteps = const [], @JsonKey(name: 'assessment_id') required this.assessmentId}): _nextSteps = nextSteps;
  factory _TriageResult.fromJson(Map<String, dynamic> json) => _$TriageResultFromJson(json);

@override final  String priority;
@override final  String? tagline;
@override final  String? reason;
 final  List<String> _nextSteps;
@override@JsonKey(name: 'next_steps') List<String> get nextSteps {
  if (_nextSteps is EqualUnmodifiableListView) return _nextSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nextSteps);
}

@override@JsonKey(name: 'assessment_id') final  int assessmentId;

/// Create a copy of TriageResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageResultCopyWith<_TriageResult> get copyWith => __$TriageResultCopyWithImpl<_TriageResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriageResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriageResult&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.tagline, tagline) || other.tagline == tagline)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._nextSteps, _nextSteps)&&(identical(other.assessmentId, assessmentId) || other.assessmentId == assessmentId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priority,tagline,reason,const DeepCollectionEquality().hash(_nextSteps),assessmentId);

@override
String toString() {
  return 'TriageResult(priority: $priority, tagline: $tagline, reason: $reason, nextSteps: $nextSteps, assessmentId: $assessmentId)';
}


}

/// @nodoc
abstract mixin class _$TriageResultCopyWith<$Res> implements $TriageResultCopyWith<$Res> {
  factory _$TriageResultCopyWith(_TriageResult value, $Res Function(_TriageResult) _then) = __$TriageResultCopyWithImpl;
@override @useResult
$Res call({
 String priority, String? tagline, String? reason,@JsonKey(name: 'next_steps') List<String> nextSteps,@JsonKey(name: 'assessment_id') int assessmentId
});




}
/// @nodoc
class __$TriageResultCopyWithImpl<$Res>
    implements _$TriageResultCopyWith<$Res> {
  __$TriageResultCopyWithImpl(this._self, this._then);

  final _TriageResult _self;
  final $Res Function(_TriageResult) _then;

/// Create a copy of TriageResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priority = null,Object? tagline = freezed,Object? reason = freezed,Object? nextSteps = null,Object? assessmentId = null,}) {
  return _then(_TriageResult(
priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,tagline: freezed == tagline ? _self.tagline : tagline // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,nextSteps: null == nextSteps ? _self._nextSteps : nextSteps // ignore: cast_nullable_to_non_nullable
as List<String>,assessmentId: null == assessmentId ? _self.assessmentId : assessmentId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
