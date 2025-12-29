// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gym_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GymProfile _$GymProfileFromJson(Map<String, dynamic> json) {
  return _GymProfile.fromJson(json);
}

/// @nodoc
mixin _$GymProfile {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Profile name (e.g., "Home Gym", "Planet Fitness", "Travel")
  String get name => throw _privateConstructorUsedError;

  /// Profile type: 'home', 'commercial', 'travel', 'outdoor', 'bodyweight'
  String get type => throw _privateConstructorUsedError;

  /// List of available equipment IDs
  List<String> get equipmentIds => throw _privateConstructorUsedError;

  /// Custom notes about this location
  String? get notes => throw _privateConstructorUsedError;

  /// Icon identifier for UI display
  String get icon => throw _privateConstructorUsedError;

  /// Whether this is the default profile
  bool get isDefault => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GymProfileCopyWith<GymProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GymProfileCopyWith<$Res> {
  factory $GymProfileCopyWith(
          GymProfile value, $Res Function(GymProfile) then) =
      _$GymProfileCopyWithImpl<$Res, GymProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      List<String> equipmentIds,
      String? notes,
      String icon,
      bool isDefault});
}

/// @nodoc
class _$GymProfileCopyWithImpl<$Res, $Val extends GymProfile>
    implements $GymProfileCopyWith<$Res> {
  _$GymProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? equipmentIds = null,
    Object? notes = freezed,
    Object? icon = null,
    Object? isDefault = null,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentIds: null == equipmentIds
          ? _value.equipmentIds
          : equipmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GymProfileImplCopyWith<$Res>
    implements $GymProfileCopyWith<$Res> {
  factory _$$GymProfileImplCopyWith(
          _$GymProfileImpl value, $Res Function(_$GymProfileImpl) then) =
      __$$GymProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      List<String> equipmentIds,
      String? notes,
      String icon,
      bool isDefault});
}

/// @nodoc
class __$$GymProfileImplCopyWithImpl<$Res>
    extends _$GymProfileCopyWithImpl<$Res, _$GymProfileImpl>
    implements _$$GymProfileImplCopyWith<$Res> {
  __$$GymProfileImplCopyWithImpl(
      _$GymProfileImpl _value, $Res Function(_$GymProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? equipmentIds = null,
    Object? notes = freezed,
    Object? icon = null,
    Object? isDefault = null,
  }) {
    return _then(_$GymProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentIds: null == equipmentIds
          ? _value._equipmentIds
          : equipmentIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GymProfileImpl implements _GymProfile {
  const _$GymProfileImpl(
      {required this.id,
      required this.name,
      required this.type,
      final List<String> equipmentIds = const [],
      this.notes,
      this.icon = 'gym',
      this.isDefault = false})
      : _equipmentIds = equipmentIds;

  factory _$GymProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$GymProfileImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Profile name (e.g., "Home Gym", "Planet Fitness", "Travel")
  @override
  final String name;

  /// Profile type: 'home', 'commercial', 'travel', 'outdoor', 'bodyweight'
  @override
  final String type;

  /// List of available equipment IDs
  final List<String> _equipmentIds;

  /// List of available equipment IDs
  @override
  @JsonKey()
  List<String> get equipmentIds {
    if (_equipmentIds is EqualUnmodifiableListView) return _equipmentIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipmentIds);
  }

  /// Custom notes about this location
  @override
  final String? notes;

  /// Icon identifier for UI display
  @override
  @JsonKey()
  final String icon;

  /// Whether this is the default profile
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'GymProfile(id: $id, name: $name, type: $type, equipmentIds: $equipmentIds, notes: $notes, icon: $icon, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GymProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._equipmentIds, _equipmentIds) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      const DeepCollectionEquality().hash(_equipmentIds),
      notes,
      icon,
      isDefault);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GymProfileImplCopyWith<_$GymProfileImpl> get copyWith =>
      __$$GymProfileImplCopyWithImpl<_$GymProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GymProfileImplToJson(
      this,
    );
  }
}

abstract class _GymProfile implements GymProfile {
  const factory _GymProfile(
      {required final String id,
      required final String name,
      required final String type,
      final List<String> equipmentIds,
      final String? notes,
      final String icon,
      final bool isDefault}) = _$GymProfileImpl;

  factory _GymProfile.fromJson(Map<String, dynamic> json) =
      _$GymProfileImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Profile name (e.g., "Home Gym", "Planet Fitness", "Travel")
  String get name;
  @override

  /// Profile type: 'home', 'commercial', 'travel', 'outdoor', 'bodyweight'
  String get type;
  @override

  /// List of available equipment IDs
  List<String> get equipmentIds;
  @override

  /// Custom notes about this location
  String? get notes;
  @override

  /// Icon identifier for UI display
  String get icon;
  @override

  /// Whether this is the default profile
  bool get isDefault;
  @override
  @JsonKey(ignore: true)
  _$$GymProfileImplCopyWith<_$GymProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
