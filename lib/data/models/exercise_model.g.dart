// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      primaryMuscleGroup: json['primaryMuscleGroup'] as String,
      secondaryMuscleGroups: (json['secondaryMuscleGroups'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      requiredEquipment: (json['requiredEquipment'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      exerciseType: json['exerciseType'] as String,
      difficulty: json['difficulty'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String?,
      videoSearchKeywords: (json['videoSearchKeywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      formTips: (json['formTips'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alternativeExerciseIds: (json['alternativeExerciseIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isBodyweight: json['isBodyweight'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'primaryMuscleGroup': instance.primaryMuscleGroup,
      'secondaryMuscleGroups': instance.secondaryMuscleGroups,
      'requiredEquipment': instance.requiredEquipment,
      'exerciseType': instance.exerciseType,
      'difficulty': instance.difficulty,
      'youtubeVideoId': instance.youtubeVideoId,
      'videoSearchKeywords': instance.videoSearchKeywords,
      'commonMistakes': instance.commonMistakes,
      'formTips': instance.formTips,
      'alternativeExerciseIds': instance.alternativeExerciseIds,
      'isBodyweight': instance.isBodyweight,
      'sortOrder': instance.sortOrder,
    };
