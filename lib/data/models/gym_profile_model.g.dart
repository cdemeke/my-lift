// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GymProfileImpl _$$GymProfileImplFromJson(Map<String, dynamic> json) =>
    _$GymProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      equipmentIds: (json['equipmentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      icon: json['icon'] as String? ?? 'gym',
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$GymProfileImplToJson(_$GymProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'equipmentIds': instance.equipmentIds,
      'notes': instance.notes,
      'icon': instance.icon,
      'isDefault': instance.isDefault,
    };
