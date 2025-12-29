// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: const TimestampConverter().fromJson(json['timestamp']),
      contextType: json['contextType'] as String? ?? 'general',
      relatedWorkoutId: json['relatedWorkoutId'] as String?,
      relatedExerciseId: json['relatedExerciseId'] as String?,
      hasSuggestedActions: json['hasSuggestedActions'] as bool? ?? false,
      suggestedActions: (json['suggestedActions'] as List<dynamic>?)
              ?.map((e) => SuggestedAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'timestamp': const TimestampConverter().toJson(instance.timestamp),
      'contextType': instance.contextType,
      'relatedWorkoutId': instance.relatedWorkoutId,
      'relatedExerciseId': instance.relatedExerciseId,
      'hasSuggestedActions': instance.hasSuggestedActions,
      'suggestedActions': instance.suggestedActions,
    };

_$SuggestedActionImpl _$$SuggestedActionImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedActionImpl(
      label: json['label'] as String,
      actionType: json['actionType'] as String,
      payload: json['payload'] as String,
    );

Map<String, dynamic> _$$SuggestedActionImplToJson(
        _$SuggestedActionImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'actionType': instance.actionType,
      'payload': instance.payload,
    };
