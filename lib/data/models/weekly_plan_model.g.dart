// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyPlanImpl _$$WeeklyPlanImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyPlanImpl(
      id: json['id'] as String,
      weekStartDate: const TimestampConverter().fromJson(json['weekStartDate']),
      weekEndDate: const TimestampConverter().fromJson(json['weekEndDate']),
      workoutIds: (json['workoutIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      gymProfileId: json['gymProfileId'] as String,
      generatedAt: const TimestampConverter().fromJson(json['generatedAt']),
      weekSummary: json['weekSummary'] as String?,
      status: json['status'] as String? ?? 'active',
      completedWorkouts: (json['completedWorkouts'] as num?)?.toInt() ?? 0,
      totalWorkouts: (json['totalWorkouts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WeeklyPlanImplToJson(_$WeeklyPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weekStartDate':
          const TimestampConverter().toJson(instance.weekStartDate),
      'weekEndDate': const TimestampConverter().toJson(instance.weekEndDate),
      'workoutIds': instance.workoutIds,
      'gymProfileId': instance.gymProfileId,
      'generatedAt': const TimestampConverter().toJson(instance.generatedAt),
      'weekSummary': instance.weekSummary,
      'status': instance.status,
      'completedWorkouts': instance.completedWorkouts,
      'totalWorkouts': instance.totalWorkouts,
    };
