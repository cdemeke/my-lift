// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutImpl _$$WorkoutImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutImpl(
      id: json['id'] as String,
      weeklyPlanId: json['weeklyPlanId'] as String,
      name: json['name'] as String,
      scheduledDate: const TimestampConverter().fromJson(json['scheduledDate']),
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => PlannedExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetMuscleGroups: (json['targetMuscleGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      startedAt: const NullableTimestampConverter().fromJson(json['startedAt']),
      completedAt:
          const NullableTimestampConverter().fromJson(json['completedAt']),
      coachNotes: json['coachNotes'] as String?,
      wasModified: json['wasModified'] as bool? ?? false,
    );

Map<String, dynamic> _$$WorkoutImplToJson(_$WorkoutImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weeklyPlanId': instance.weeklyPlanId,
      'name': instance.name,
      'scheduledDate':
          const TimestampConverter().toJson(instance.scheduledDate),
      'dayOfWeek': instance.dayOfWeek,
      'exercises': instance.exercises,
      'targetMuscleGroups': instance.targetMuscleGroups,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'status': instance.status,
      'startedAt':
          const NullableTimestampConverter().toJson(instance.startedAt),
      'completedAt':
          const NullableTimestampConverter().toJson(instance.completedAt),
      'coachNotes': instance.coachNotes,
      'wasModified': instance.wasModified,
    };

_$PlannedExerciseImpl _$$PlannedExerciseImplFromJson(
        Map<String, dynamic> json) =>
    _$PlannedExerciseImpl(
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      order: (json['order'] as num).toInt(),
      targetSets: (json['targetSets'] as num).toInt(),
      targetReps: json['targetReps'] as String,
      restSeconds: (json['restSeconds'] as num?)?.toInt() ?? 90,
      notes: json['notes'] as String?,
      wasSwapped: json['wasSwapped'] as bool? ?? false,
      originalExerciseId: json['originalExerciseId'] as String?,
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$$PlannedExerciseImplToJson(
        _$PlannedExerciseImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'order': instance.order,
      'targetSets': instance.targetSets,
      'targetReps': instance.targetReps,
      'restSeconds': instance.restSeconds,
      'notes': instance.notes,
      'wasSwapped': instance.wasSwapped,
      'originalExerciseId': instance.originalExerciseId,
      'status': instance.status,
    };
