// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  /// Firebase Auth UID - serves as document ID
  String get uid => throw _privateConstructorUsedError;

  /// User's display name
  String get displayName => throw _privateConstructorUsedError;

  /// Email address
  String get email => throw _privateConstructorUsedError;

  /// Profile photo URL (nullable for email-only signups)
  String? get photoUrl => throw _privateConstructorUsedError;

  /// User's fitness goals configuration
  FitnessGoals get fitnessGoals => throw _privateConstructorUsedError;

  /// ID of the currently active gym profile
  String get activeGymProfileId => throw _privateConstructorUsedError;

  /// Whether user has completed onboarding flow
  bool get onboardingComplete => throw _privateConstructorUsedError;

  /// FCM token for push notifications
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Preferred weight unit: 'lbs' or 'kg'
  String get weightUnit => throw _privateConstructorUsedError;

  /// Account creation timestamp
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last activity timestamp
  @TimestampConverter()
  DateTime get lastActiveAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String email,
      String? photoUrl,
      FitnessGoals fitnessGoals,
      String activeGymProfileId,
      bool onboardingComplete,
      String? fcmToken,
      String weightUnit,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime lastActiveAt});

  $FitnessGoalsCopyWith<$Res> get fitnessGoals;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? fitnessGoals = null,
    Object? activeGymProfileId = null,
    Object? onboardingComplete = null,
    Object? fcmToken = freezed,
    Object? weightUnit = null,
    Object? createdAt = null,
    Object? lastActiveAt = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fitnessGoals: null == fitnessGoals
          ? _value.fitnessGoals
          : fitnessGoals // ignore: cast_nullable_to_non_nullable
              as FitnessGoals,
      activeGymProfileId: null == activeGymProfileId
          ? _value.activeGymProfileId
          : activeGymProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingComplete: null == onboardingComplete
          ? _value.onboardingComplete
          : onboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      weightUnit: null == weightUnit
          ? _value.weightUnit
          : weightUnit // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FitnessGoalsCopyWith<$Res> get fitnessGoals {
    return $FitnessGoalsCopyWith<$Res>(_value.fitnessGoals, (value) {
      return _then(_value.copyWith(fitnessGoals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String email,
      String? photoUrl,
      FitnessGoals fitnessGoals,
      String activeGymProfileId,
      bool onboardingComplete,
      String? fcmToken,
      String weightUnit,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime lastActiveAt});

  @override
  $FitnessGoalsCopyWith<$Res> get fitnessGoals;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? email = null,
    Object? photoUrl = freezed,
    Object? fitnessGoals = null,
    Object? activeGymProfileId = null,
    Object? onboardingComplete = null,
    Object? fcmToken = freezed,
    Object? weightUnit = null,
    Object? createdAt = null,
    Object? lastActiveAt = null,
  }) {
    return _then(_$UserModelImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      fitnessGoals: null == fitnessGoals
          ? _value.fitnessGoals
          : fitnessGoals // ignore: cast_nullable_to_non_nullable
              as FitnessGoals,
      activeGymProfileId: null == activeGymProfileId
          ? _value.activeGymProfileId
          : activeGymProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingComplete: null == onboardingComplete
          ? _value.onboardingComplete
          : onboardingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      weightUnit: null == weightUnit
          ? _value.weightUnit
          : weightUnit // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActiveAt: null == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {required this.uid,
      required this.displayName,
      required this.email,
      this.photoUrl,
      required this.fitnessGoals,
      required this.activeGymProfileId,
      this.onboardingComplete = false,
      this.fcmToken,
      this.weightUnit = 'lbs',
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.lastActiveAt});

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  /// Firebase Auth UID - serves as document ID
  @override
  final String uid;

  /// User's display name
  @override
  final String displayName;

  /// Email address
  @override
  final String email;

  /// Profile photo URL (nullable for email-only signups)
  @override
  final String? photoUrl;

  /// User's fitness goals configuration
  @override
  final FitnessGoals fitnessGoals;

  /// ID of the currently active gym profile
  @override
  final String activeGymProfileId;

  /// Whether user has completed onboarding flow
  @override
  @JsonKey()
  final bool onboardingComplete;

  /// FCM token for push notifications
  @override
  final String? fcmToken;

  /// Preferred weight unit: 'lbs' or 'kg'
  @override
  @JsonKey()
  final String weightUnit;

  /// Account creation timestamp
  @override
  @TimestampConverter()
  final DateTime createdAt;

  /// Last activity timestamp
  @override
  @TimestampConverter()
  final DateTime lastActiveAt;

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email, photoUrl: $photoUrl, fitnessGoals: $fitnessGoals, activeGymProfileId: $activeGymProfileId, onboardingComplete: $onboardingComplete, fcmToken: $fcmToken, weightUnit: $weightUnit, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.fitnessGoals, fitnessGoals) ||
                other.fitnessGoals == fitnessGoals) &&
            (identical(other.activeGymProfileId, activeGymProfileId) ||
                other.activeGymProfileId == activeGymProfileId) &&
            (identical(other.onboardingComplete, onboardingComplete) ||
                other.onboardingComplete == onboardingComplete) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      displayName,
      email,
      photoUrl,
      fitnessGoals,
      activeGymProfileId,
      onboardingComplete,
      fcmToken,
      weightUnit,
      createdAt,
      lastActiveAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
          {required final String uid,
          required final String displayName,
          required final String email,
          final String? photoUrl,
          required final FitnessGoals fitnessGoals,
          required final String activeGymProfileId,
          final bool onboardingComplete,
          final String? fcmToken,
          final String weightUnit,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime lastActiveAt}) =
      _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override

  /// Firebase Auth UID - serves as document ID
  String get uid;
  @override

  /// User's display name
  String get displayName;
  @override

  /// Email address
  String get email;
  @override

  /// Profile photo URL (nullable for email-only signups)
  String? get photoUrl;
  @override

  /// User's fitness goals configuration
  FitnessGoals get fitnessGoals;
  @override

  /// ID of the currently active gym profile
  String get activeGymProfileId;
  @override

  /// Whether user has completed onboarding flow
  bool get onboardingComplete;
  @override

  /// FCM token for push notifications
  String? get fcmToken;
  @override

  /// Preferred weight unit: 'lbs' or 'kg'
  String get weightUnit;
  @override

  /// Account creation timestamp
  @TimestampConverter()
  DateTime get createdAt;
  @override

  /// Last activity timestamp
  @TimestampConverter()
  DateTime get lastActiveAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
