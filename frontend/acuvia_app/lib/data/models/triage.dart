class TriageRequest {
  final int age;
  final String sex;
  final List<String> symptoms;
  final List<String> conditions;
  final String freeText;

  const TriageRequest({
    required this.age,
    required this.sex,
    required this.symptoms,
    required this.conditions,
    required this.freeText,
  });

  factory TriageRequest.fromJson(Map<String, dynamic> json) {
    return TriageRequest(
      age: json['age'] as int,
      sex: json['sex'] as String,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      conditions: List<String>.from(json['conditions'] ?? []),
      freeText: json['free_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'sex': sex,
      'symptoms': symptoms,
      'conditions': conditions,
      'free_text': freeText,
    };
  }
}

class TriageResult {
  final int assessmentId;
  final String priority;
  final String? tagline;
  final String? reason;
  final List<String> nextSteps;

  const TriageResult({
    required this.assessmentId,
    required this.priority,
    this.tagline,
    this.reason,
    required this.nextSteps,
  });

  factory TriageResult.fromJson(Map<String, dynamic> json) {
    return TriageResult(
      assessmentId: json['assessment_id'] as int,
      priority: json['priority'] as String,
      tagline: json['tagline'] as String?,
      reason: json['reason'] as String?,
      nextSteps: List<String>.from(json['next_steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessment_id': assessmentId,
      'priority': priority,
      'tagline': tagline,
      'reason': reason,
      'next_steps': nextSteps,
    };
  }
}