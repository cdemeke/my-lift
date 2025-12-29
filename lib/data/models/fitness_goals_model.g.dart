// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_goals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FitnessGoalsImpl _$$FitnessGoalsImplFromJson(Map<String, dynamic> json) =>
    _$FitnessGoalsImpl(
      primaryGoal: json['primaryGoal'] as String? ?? 'general_fitness',
      experienceLevel: json['experienceLevel'] as String? ?? 'beginner',
      workoutDaysPerWeek: (json['workoutDaysPerWeek'] as num?)?.toInt() ?? 4,
      preferredDurationMinutes:
          (json['preferredDurationMinutes'] as num?)?.toInt() ?? 45,
      strengthFocus: (json['strengthFocus'] as num?)?.toDouble() ?? 0.5,
      cardioFocus: (json['cardioFocus'] as num?)?.toDouble() ?? 0.3,
      mobilityFocus: (json['mobilityFocus'] as num?)?.toDouble() ?? 0.2,
      injuryNotes: (json['injuryNotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FitnessGoalsImplToJson(_$FitnessGoalsImpl instance) =>
    <String, dynamic>{
      'primaryGoal': instance.primaryGoal,
      'experienceLevel': instance.experienceLevel,
      'workoutDaysPerWeek': instance.workoutDaysPerWeek,
      'preferredDurationMinutes': instance.preferredDurationMinutes,
      'strengthFocus': instance.strengthFocus,
      'cardioFocus': instance.cardioFocus,
      'mobilityFocus': instance.mobilityFocus,
      'injuryNotes': instance.injuryNotes,
    };
