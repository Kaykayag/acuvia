// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TriageRequest _$TriageRequestFromJson(Map<String, dynamic> json) =>
    _TriageRequest(
      symptoms: (json['symptoms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      freeText: json['free_text'] as String? ?? '',
      age: (json['age'] as num).toInt(),
      sex: json['sex'] as String,
      conditions:
          (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TriageRequestToJson(_TriageRequest instance) =>
    <String, dynamic>{
      'symptoms': instance.symptoms,
      'free_text': instance.freeText,
      'age': instance.age,
      'sex': instance.sex,
      'conditions': instance.conditions,
    };

_TriageResult _$TriageResultFromJson(Map<String, dynamic> json) =>
    _TriageResult(
      priority: json['priority'] as String,
      tagline: json['tagline'] as String?,
      reason: json['reason'] as String?,
      nextSteps:
          (json['next_steps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assessmentId: (json['assessment_id'] as num).toInt(),
    );

Map<String, dynamic> _$TriageResultToJson(_TriageResult instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'tagline': instance.tagline,
      'reason': instance.reason,
      'next_steps': instance.nextSteps,
      'assessment_id': instance.assessmentId,
    };
