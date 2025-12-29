// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return _Equipment.fromJson(json);
}

/// @nodoc
mixin _$Equipment {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Equipment name
  String get name => throw _privateConstructorUsedError;

  /// Category: 'free_weights', 'machines', 'cables', 'cardio', 'bodyweight', 'other'
  String get category => throw _privateConstructorUsedError;

  /// Icon asset path or identifier
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Whether commonly found in home gyms
  bool get commonInHomeGym => throw _privateConstructorUsedError;

  /// Whether commonly found in commercial gyms
  bool get commonInCommercialGym => throw _privateConstructorUsedError;

  /// Sort order for display
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EquipmentCopyWith<Equipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCopyWith<$Res> {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) then) =
      _$EquipmentCopyWithImpl<$Res, Equipment>;
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      String? iconUrl,
      bool commonInHomeGym,
      bool commonInCommercialGym,
      int sortOrder});
}

/// @nodoc
class _$EquipmentCopyWithImpl<$Res, $Val extends Equipment>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? iconUrl = freezed,
    Object? commonInHomeGym = null,
    Object? commonInCommercialGym = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      commonInHomeGym: null == commonInHomeGym
          ? _value.commonInHomeGym
          : commonInHomeGym // ignore: cast_nullable_to_non_nullable
              as bool,
      commonInCommercialGym: null == commonInCommercialGym
          ? _value.commonInCommercialGym
          : commonInCommercialGym // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentImplCopyWith<$Res>
    implements $EquipmentCopyWith<$Res> {
  factory _$$EquipmentImplCopyWith(
          _$EquipmentImpl value, $Res Function(_$EquipmentImpl) then) =
      __$$EquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String category,
      String? iconUrl,
      bool commonInHomeGym,
      bool commonInCommercialGym,
      int sortOrder});
}

/// @nodoc
class __$$EquipmentImplCopyWithImpl<$Res>
    extends _$EquipmentCopyWithImpl<$Res, _$EquipmentImpl>
    implements _$$EquipmentImplCopyWith<$Res> {
  __$$EquipmentImplCopyWithImpl(
      _$EquipmentImpl _value, $Res Function(_$EquipmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? iconUrl = freezed,
    Object? commonInHomeGym = null,
    Object? commonInCommercialGym = null,
    Object? sortOrder = null,
  }) {
    return _then(_$EquipmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      commonInHomeGym: null == commonInHomeGym
          ? _value.commonInHomeGym
          : commonInHomeGym // ignore: cast_nullable_to_non_nullable
              as bool,
      commonInCommercialGym: null == commonInCommercialGym
          ? _value.commonInCommercialGym
          : commonInCommercialGym // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentImpl implements _Equipment {
  const _$EquipmentImpl(
      {required this.id,
      required this.name,
      required this.category,
      this.iconUrl,
      this.commonInHomeGym = false,
      this.commonInCommercialGym = true,
      this.sortOrder = 0});

  factory _$EquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Equipment name
  @override
  final String name;

  /// Category: 'free_weights', 'machines', 'cables', 'cardio', 'bodyweight', 'other'
  @override
  final String category;

  /// Icon asset path or identifier
  @override
  final String? iconUrl;

  /// Whether commonly found in home gyms
  @override
  @JsonKey()
  final bool commonInHomeGym;

  /// Whether commonly found in commercial gyms
  @override
  @JsonKey()
  final bool commonInCommercialGym;

  /// Sort order for display
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'Equipment(id: $id, name: $name, category: $category, iconUrl: $iconUrl, commonInHomeGym: $commonInHomeGym, commonInCommercialGym: $commonInCommercialGym, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.commonInHomeGym, commonInHomeGym) ||
                other.commonInHomeGym == commonInHomeGym) &&
            (identical(other.commonInCommercialGym, commonInCommercialGym) ||
                other.commonInCommercialGym == commonInCommercialGym) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, category, iconUrl,
      commonInHomeGym, commonInCommercialGym, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      __$$EquipmentImplCopyWithImpl<_$EquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentImplToJson(
      this,
    );
  }
}

abstract class _Equipment implements Equipment {
  const factory _Equipment(
      {required final String id,
      required final String name,
      required final String category,
      final String? iconUrl,
      final bool commonInHomeGym,
      final bool commonInCommercialGym,
      final int sortOrder}) = _$EquipmentImpl;

  factory _Equipment.fromJson(Map<String, dynamic> json) =
      _$EquipmentImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Equipment name
  String get name;
  @override

  /// Category: 'free_weights', 'machines', 'cables', 'cardio', 'bodyweight', 'other'
  String get category;
  @override

  /// Icon asset path or identifier
  String? get iconUrl;
  @override

  /// Whether commonly found in home gyms
  bool get commonInHomeGym;
  @override

  /// Whether commonly found in commercial gyms
  bool get commonInCommercialGym;
  @override

  /// Sort order for display
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
