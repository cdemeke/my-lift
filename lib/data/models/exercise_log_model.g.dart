// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseLogImpl _$$ExerciseLogImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseLogImpl(
      id: json['id'] as String,
      workoutId: json['workoutId'] as String,
      exerciseId: json['exerciseId'] as String,
      exerciseName: json['exerciseName'] as String,
      sets: (json['sets'] as List<dynamic>?)
              ?.map((e) => SetLog.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      loggedAt: const TimestampConverter().fromJson(json['loggedAt']),
      userNotes: json['userNotes'] as String?,
      loggedRealTime: json['loggedRealTime'] as bool? ?? false,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
    );

Map<String, dynamic> _$$ExerciseLogImplToJson(_$ExerciseLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workoutId': instance.workoutId,
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'sets': instance.sets,
      'loggedAt': const TimestampConverter().toJson(instance.loggedAt),
      'userNotes': instance.userNotes,
      'loggedRealTime': instance.loggedRealTime,
      'syncStatus': instance.syncStatus,
    };

_$SetLogImpl _$$SetLogImplFromJson(Map<String, dynamic> json) => _$SetLogImpl(
      setNumber: (json['setNumber'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      weightUnit: json['weightUnit'] as String? ?? 'lbs',
      isWarmup: json['isWarmup'] as bool? ?? false,
      isDropSet: json['isDropSet'] as bool? ?? false,
      isToFailure: json['isToFailure'] as bool? ?? false,
      difficulty: json['difficulty'] as String?,
      completedAt:
          const NullableTimestampConverter().fromJson(json['completedAt']),
    );

Map<String, dynamic> _$$SetLogImplToJson(_$SetLogImpl instance) =>
    <String, dynamic>{
      'setNumber': instance.setNumber,
      'reps': instance.reps,
      'weight': instance.weight,
      'weightUnit': instance.weightUnit,
      'isWarmup': instance.isWarmup,
      'isDropSet': instance.isDropSet,
      'isToFailure': instance.isToFailure,
      'difficulty': instance.difficulty,
      'completedAt':
          const NullableTimestampConverter().toJson(instance.completedAt),
    };
