// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      iconUrl: json['iconUrl'] as String?,
      commonInHomeGym: json['commonInHomeGym'] as bool? ?? false,
      commonInCommercialGym: json['commonInCommercialGym'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'iconUrl': instance.iconUrl,
      'commonInHomeGym': instance.commonInHomeGym,
      'commonInCommercialGym': instance.commonInCommercialGym,
      'sortOrder': instance.sortOrder,
    };
