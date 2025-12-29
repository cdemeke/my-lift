// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyPlan _$WeeklyPlanFromJson(Map<String, dynamic> json) {
  return _WeeklyPlan.fromJson(json);
}

/// @nodoc
mixin _$WeeklyPlan {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Start date of the week (Monday)
  @TimestampConverter()
  DateTime get weekStartDate => throw _privateConstructorUsedError;

  /// End date of the week (Sunday)
  @TimestampConverter()
  DateTime get weekEndDate => throw _privateConstructorUsedError;

  /// List of workout IDs for this week
  List<String> get workoutIds => throw _privateConstructorUsedError;

  /// Gym profile ID used for generation
  String get gymProfileId => throw _privateConstructorUsedError;

  /// When the plan was generated
  @TimestampConverter()
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// AI-generated summary of the week's focus
  String? get weekSummary => throw _privateConstructorUsedError;

  /// Status: 'active', 'completed', 'archived'
  String get status => throw _privateConstructorUsedError;

  /// Number of workouts completed this week
  int get completedWorkouts => throw _privateConstructorUsedError;

  /// Total workouts planned
  int get totalWorkouts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyPlanCopyWith<WeeklyPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyPlanCopyWith<$Res> {
  factory $WeeklyPlanCopyWith(
          WeeklyPlan value, $Res Function(WeeklyPlan) then) =
      _$WeeklyPlanCopyWithImpl<$Res, WeeklyPlan>;
  @useResult
  $Res call(
      {String id,
      @TimestampConverter() DateTime weekStartDate,
      @TimestampConverter() DateTime weekEndDate,
      List<String> workoutIds,
      String gymProfileId,
      @TimestampConverter() DateTime generatedAt,
      String? weekSummary,
      String status,
      int completedWorkouts,
      int totalWorkouts});
}

/// @nodoc
class _$WeeklyPlanCopyWithImpl<$Res, $Val extends WeeklyPlan>
    implements $WeeklyPlanCopyWith<$Res> {
  _$WeeklyPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekStartDate = null,
    Object? weekEndDate = null,
    Object? workoutIds = null,
    Object? gymProfileId = null,
    Object? generatedAt = null,
    Object? weekSummary = freezed,
    Object? status = null,
    Object? completedWorkouts = null,
    Object? totalWorkouts = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStartDate: null == weekStartDate
          ? _value.weekStartDate
          : weekStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekEndDate: null == weekEndDate
          ? _value.weekEndDate
          : weekEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutIds: null == workoutIds
          ? _value.workoutIds
          : workoutIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gymProfileId: null == gymProfileId
          ? _value.gymProfileId
          : gymProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekSummary: freezed == weekSummary
          ? _value.weekSummary
          : weekSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completedWorkouts: null == completedWorkouts
          ? _value.completedWorkouts
          : completedWorkouts // ignore: cast_nullable_to_non_nullable
              as int,
      totalWorkouts: null == totalWorkouts
          ? _value.totalWorkouts
          : totalWorkouts // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyPlanImplCopyWith<$Res>
    implements $WeeklyPlanCopyWith<$Res> {
  factory _$$WeeklyPlanImplCopyWith(
          _$WeeklyPlanImpl value, $Res Function(_$WeeklyPlanImpl) then) =
      __$$WeeklyPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @TimestampConverter() DateTime weekStartDate,
      @TimestampConverter() DateTime weekEndDate,
      List<String> workoutIds,
      String gymProfileId,
      @TimestampConverter() DateTime generatedAt,
      String? weekSummary,
      String status,
      int completedWorkouts,
      int totalWorkouts});
}

/// @nodoc
class __$$WeeklyPlanImplCopyWithImpl<$Res>
    extends _$WeeklyPlanCopyWithImpl<$Res, _$WeeklyPlanImpl>
    implements _$$WeeklyPlanImplCopyWith<$Res> {
  __$$WeeklyPlanImplCopyWithImpl(
      _$WeeklyPlanImpl _value, $Res Function(_$WeeklyPlanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekStartDate = null,
    Object? weekEndDate = null,
    Object? workoutIds = null,
    Object? gymProfileId = null,
    Object? generatedAt = null,
    Object? weekSummary = freezed,
    Object? status = null,
    Object? completedWorkouts = null,
    Object? totalWorkouts = null,
  }) {
    return _then(_$WeeklyPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStartDate: null == weekStartDate
          ? _value.weekStartDate
          : weekStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekEndDate: null == weekEndDate
          ? _value.weekEndDate
          : weekEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      workoutIds: null == workoutIds
          ? _value._workoutIds
          : workoutIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gymProfileId: null == gymProfileId
          ? _value.gymProfileId
          : gymProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekSummary: freezed == weekSummary
          ? _value.weekSummary
          : weekSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      completedWorkouts: null == completedWorkouts
          ? _value.completedWorkouts
          : completedWorkouts // ignore: cast_nullable_to_non_nullable
              as int,
      totalWorkouts: null == totalWorkouts
          ? _value.totalWorkouts
          : totalWorkouts // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyPlanImpl implements _WeeklyPlan {
  const _$WeeklyPlanImpl(
      {required this.id,
      @TimestampConverter() required this.weekStartDate,
      @TimestampConverter() required this.weekEndDate,
      final List<String> workoutIds = const [],
      required this.gymProfileId,
      @TimestampConverter() required this.generatedAt,
      this.weekSummary,
      this.status = 'active',
      this.completedWorkouts = 0,
      this.totalWorkouts = 0})
      : _workoutIds = workoutIds;

  factory _$WeeklyPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyPlanImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Start date of the week (Monday)
  @override
  @TimestampConverter()
  final DateTime weekStartDate;

  /// End date of the week (Sunday)
  @override
  @TimestampConverter()
  final DateTime weekEndDate;

  /// List of workout IDs for this week
  final List<String> _workoutIds;

  /// List of workout IDs for this week
  @override
  @JsonKey()
  List<String> get workoutIds {
    if (_workoutIds is EqualUnmodifiableListView) return _workoutIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutIds);
  }

  /// Gym profile ID used for generation
  @override
  final String gymProfileId;

  /// When the plan was generated
  @override
  @TimestampConverter()
  final DateTime generatedAt;

  /// AI-generated summary of the week's focus
  @override
  final String? weekSummary;

  /// Status: 'active', 'completed', 'archived'
  @override
  @JsonKey()
  final String status;

  /// Number of workouts completed this week
  @override
  @JsonKey()
  final int completedWorkouts;

  /// Total workouts planned
  @override
  @JsonKey()
  final int totalWorkouts;

  @override
  String toString() {
    return 'WeeklyPlan(id: $id, weekStartDate: $weekStartDate, weekEndDate: $weekEndDate, workoutIds: $workoutIds, gymProfileId: $gymProfileId, generatedAt: $generatedAt, weekSummary: $weekSummary, status: $status, completedWorkouts: $completedWorkouts, totalWorkouts: $totalWorkouts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekStartDate, weekStartDate) ||
                other.weekStartDate == weekStartDate) &&
            (identical(other.weekEndDate, weekEndDate) ||
                other.weekEndDate == weekEndDate) &&
            const DeepCollectionEquality()
                .equals(other._workoutIds, _workoutIds) &&
            (identical(other.gymProfileId, gymProfileId) ||
                other.gymProfileId == gymProfileId) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.weekSummary, weekSummary) ||
                other.weekSummary == weekSummary) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completedWorkouts, completedWorkouts) ||
                other.completedWorkouts == completedWorkouts) &&
            (identical(other.totalWorkouts, totalWorkouts) ||
                other.totalWorkouts == totalWorkouts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      weekStartDate,
      weekEndDate,
      const DeepCollectionEquality().hash(_workoutIds),
      gymProfileId,
      generatedAt,
      weekSummary,
      status,
      completedWorkouts,
      totalWorkouts);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyPlanImplCopyWith<_$WeeklyPlanImpl> get copyWith =>
      __$$WeeklyPlanImplCopyWithImpl<_$WeeklyPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyPlanImplToJson(
      this,
    );
  }
}

abstract class _WeeklyPlan implements WeeklyPlan {
  const factory _WeeklyPlan(
      {required final String id,
      @TimestampConverter() required final DateTime weekStartDate,
      @TimestampConverter() required final DateTime weekEndDate,
      final List<String> workoutIds,
      required final String gymProfileId,
      @TimestampConverter() required final DateTime generatedAt,
      final String? weekSummary,
      final String status,
      final int completedWorkouts,
      final int totalWorkouts}) = _$WeeklyPlanImpl;

  factory _WeeklyPlan.fromJson(Map<String, dynamic> json) =
      _$WeeklyPlanImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Start date of the week (Monday)
  @TimestampConverter()
  DateTime get weekStartDate;
  @override

  /// End date of the week (Sunday)
  @TimestampConverter()
  DateTime get weekEndDate;
  @override

  /// List of workout IDs for this week
  List<String> get workoutIds;
  @override

  /// Gym profile ID used for generation
  String get gymProfileId;
  @override

  /// When the plan was generated
  @TimestampConverter()
  DateTime get generatedAt;
  @override

  /// AI-generated summary of the week's focus
  String? get weekSummary;
  @override

  /// Status: 'active', 'completed', 'archived'
  String get status;
  @override

  /// Number of workouts completed this week
  int get completedWorkouts;
  @override

  /// Total workouts planned
  int get totalWorkouts;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyPlanImplCopyWith<_$WeeklyPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
