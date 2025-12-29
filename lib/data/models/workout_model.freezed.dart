// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Workout _$WorkoutFromJson(Map<String, dynamic> json) {
  return _Workout.fromJson(json);
}

/// @nodoc
mixin _$Workout {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Reference to parent weekly plan
  String get weeklyPlanId => throw _privateConstructorUsedError;

  /// Workout name (e.g., "Push Day", "Full Body A")
  String get name => throw _privateConstructorUsedError;

  /// Scheduled date for this workout
  @TimestampConverter()
  DateTime get scheduledDate => throw _privateConstructorUsedError;

  /// Day of week (1=Monday, 7=Sunday)
  int get dayOfWeek => throw _privateConstructorUsedError;

  /// List of planned exercises
  List<PlannedExercise> get exercises => throw _privateConstructorUsedError;

  /// Workout focus areas
  List<String> get targetMuscleGroups => throw _privateConstructorUsedError;

  /// Estimated duration in minutes
  int get estimatedDurationMinutes => throw _privateConstructorUsedError;

  /// Status: 'pending', 'in_progress', 'completed', 'skipped'
  String get status => throw _privateConstructorUsedError;

  /// When workout was started (null if not started)
  @NullableTimestampConverter()
  DateTime? get startedAt => throw _privateConstructorUsedError;

  /// When workout was completed (null if not completed)
  @NullableTimestampConverter()
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// AI-generated notes/tips for this workout
  String? get coachNotes => throw _privateConstructorUsedError;

  /// Whether this workout was modified from original plan
  bool get wasModified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkoutCopyWith<Workout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutCopyWith<$Res> {
  factory $WorkoutCopyWith(Workout value, $Res Function(Workout) then) =
      _$WorkoutCopyWithImpl<$Res, Workout>;
  @useResult
  $Res call(
      {String id,
      String weeklyPlanId,
      String name,
      @TimestampConverter() DateTime scheduledDate,
      int dayOfWeek,
      List<PlannedExercise> exercises,
      List<String> targetMuscleGroups,
      int estimatedDurationMinutes,
      String status,
      @NullableTimestampConverter() DateTime? startedAt,
      @NullableTimestampConverter() DateTime? completedAt,
      String? coachNotes,
      bool wasModified});
}

/// @nodoc
class _$WorkoutCopyWithImpl<$Res, $Val extends Workout>
    implements $WorkoutCopyWith<$Res> {
  _$WorkoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weeklyPlanId = null,
    Object? name = null,
    Object? scheduledDate = null,
    Object? dayOfWeek = null,
    Object? exercises = null,
    Object? targetMuscleGroups = null,
    Object? estimatedDurationMinutes = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? coachNotes = freezed,
    Object? wasModified = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyPlanId: null == weeklyPlanId
          ? _value.weeklyPlanId
          : weeklyPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<PlannedExercise>,
      targetMuscleGroups: null == targetMuscleGroups
          ? _value.targetMuscleGroups
          : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedDurationMinutes: null == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasModified: null == wasModified
          ? _value.wasModified
          : wasModified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutImplCopyWith<$Res> implements $WorkoutCopyWith<$Res> {
  factory _$$WorkoutImplCopyWith(
          _$WorkoutImpl value, $Res Function(_$WorkoutImpl) then) =
      __$$WorkoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String weeklyPlanId,
      String name,
      @TimestampConverter() DateTime scheduledDate,
      int dayOfWeek,
      List<PlannedExercise> exercises,
      List<String> targetMuscleGroups,
      int estimatedDurationMinutes,
      String status,
      @NullableTimestampConverter() DateTime? startedAt,
      @NullableTimestampConverter() DateTime? completedAt,
      String? coachNotes,
      bool wasModified});
}

/// @nodoc
class __$$WorkoutImplCopyWithImpl<$Res>
    extends _$WorkoutCopyWithImpl<$Res, _$WorkoutImpl>
    implements _$$WorkoutImplCopyWith<$Res> {
  __$$WorkoutImplCopyWithImpl(
      _$WorkoutImpl _value, $Res Function(_$WorkoutImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weeklyPlanId = null,
    Object? name = null,
    Object? scheduledDate = null,
    Object? dayOfWeek = null,
    Object? exercises = null,
    Object? targetMuscleGroups = null,
    Object? estimatedDurationMinutes = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? coachNotes = freezed,
    Object? wasModified = null,
  }) {
    return _then(_$WorkoutImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weeklyPlanId: null == weeklyPlanId
          ? _value.weeklyPlanId
          : weeklyPlanId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dayOfWeek: null == dayOfWeek
          ? _value.dayOfWeek
          : dayOfWeek // ignore: cast_nullable_to_non_nullable
              as int,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<PlannedExercise>,
      targetMuscleGroups: null == targetMuscleGroups
          ? _value._targetMuscleGroups
          : targetMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedDurationMinutes: null == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coachNotes: freezed == coachNotes
          ? _value.coachNotes
          : coachNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasModified: null == wasModified
          ? _value.wasModified
          : wasModified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutImpl implements _Workout {
  const _$WorkoutImpl(
      {required this.id,
      required this.weeklyPlanId,
      required this.name,
      @TimestampConverter() required this.scheduledDate,
      required this.dayOfWeek,
      required final List<PlannedExercise> exercises,
      final List<String> targetMuscleGroups = const [],
      required this.estimatedDurationMinutes,
      this.status = 'pending',
      @NullableTimestampConverter() this.startedAt,
      @NullableTimestampConverter() this.completedAt,
      this.coachNotes,
      this.wasModified = false})
      : _exercises = exercises,
        _targetMuscleGroups = targetMuscleGroups;

  factory _$WorkoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Reference to parent weekly plan
  @override
  final String weeklyPlanId;

  /// Workout name (e.g., "Push Day", "Full Body A")
  @override
  final String name;

  /// Scheduled date for this workout
  @override
  @TimestampConverter()
  final DateTime scheduledDate;

  /// Day of week (1=Monday, 7=Sunday)
  @override
  final int dayOfWeek;

  /// List of planned exercises
  final List<PlannedExercise> _exercises;

  /// List of planned exercises
  @override
  List<PlannedExercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  /// Workout focus areas
  final List<String> _targetMuscleGroups;

  /// Workout focus areas
  @override
  @JsonKey()
  List<String> get targetMuscleGroups {
    if (_targetMuscleGroups is EqualUnmodifiableListView)
      return _targetMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscleGroups);
  }

  /// Estimated duration in minutes
  @override
  final int estimatedDurationMinutes;

  /// Status: 'pending', 'in_progress', 'completed', 'skipped'
  @override
  @JsonKey()
  final String status;

  /// When workout was started (null if not started)
  @override
  @NullableTimestampConverter()
  final DateTime? startedAt;

  /// When workout was completed (null if not completed)
  @override
  @NullableTimestampConverter()
  final DateTime? completedAt;

  /// AI-generated notes/tips for this workout
  @override
  final String? coachNotes;

  /// Whether this workout was modified from original plan
  @override
  @JsonKey()
  final bool wasModified;

  @override
  String toString() {
    return 'Workout(id: $id, weeklyPlanId: $weeklyPlanId, name: $name, scheduledDate: $scheduledDate, dayOfWeek: $dayOfWeek, exercises: $exercises, targetMuscleGroups: $targetMuscleGroups, estimatedDurationMinutes: $estimatedDurationMinutes, status: $status, startedAt: $startedAt, completedAt: $completedAt, coachNotes: $coachNotes, wasModified: $wasModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weeklyPlanId, weeklyPlanId) ||
                other.weeklyPlanId == weeklyPlanId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            const DeepCollectionEquality()
                .equals(other._targetMuscleGroups, _targetMuscleGroups) &&
            (identical(
                    other.estimatedDurationMinutes, estimatedDurationMinutes) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.coachNotes, coachNotes) ||
                other.coachNotes == coachNotes) &&
            (identical(other.wasModified, wasModified) ||
                other.wasModified == wasModified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      weeklyPlanId,
      name,
      scheduledDate,
      dayOfWeek,
      const DeepCollectionEquality().hash(_exercises),
      const DeepCollectionEquality().hash(_targetMuscleGroups),
      estimatedDurationMinutes,
      status,
      startedAt,
      completedAt,
      coachNotes,
      wasModified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      __$$WorkoutImplCopyWithImpl<_$WorkoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutImplToJson(
      this,
    );
  }
}

abstract class _Workout implements Workout {
  const factory _Workout(
      {required final String id,
      required final String weeklyPlanId,
      required final String name,
      @TimestampConverter() required final DateTime scheduledDate,
      required final int dayOfWeek,
      required final List<PlannedExercise> exercises,
      final List<String> targetMuscleGroups,
      required final int estimatedDurationMinutes,
      final String status,
      @NullableTimestampConverter() final DateTime? startedAt,
      @NullableTimestampConverter() final DateTime? completedAt,
      final String? coachNotes,
      final bool wasModified}) = _$WorkoutImpl;

  factory _Workout.fromJson(Map<String, dynamic> json) = _$WorkoutImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Reference to parent weekly plan
  String get weeklyPlanId;
  @override

  /// Workout name (e.g., "Push Day", "Full Body A")
  String get name;
  @override

  /// Scheduled date for this workout
  @TimestampConverter()
  DateTime get scheduledDate;
  @override

  /// Day of week (1=Monday, 7=Sunday)
  int get dayOfWeek;
  @override

  /// List of planned exercises
  List<PlannedExercise> get exercises;
  @override

  /// Workout focus areas
  List<String> get targetMuscleGroups;
  @override

  /// Estimated duration in minutes
  int get estimatedDurationMinutes;
  @override

  /// Status: 'pending', 'in_progress', 'completed', 'skipped'
  String get status;
  @override

  /// When workout was started (null if not started)
  @NullableTimestampConverter()
  DateTime? get startedAt;
  @override

  /// When workout was completed (null if not completed)
  @NullableTimestampConverter()
  DateTime? get completedAt;
  @override

  /// AI-generated notes/tips for this workout
  String? get coachNotes;
  @override

  /// Whether this workout was modified from original plan
  bool get wasModified;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutImplCopyWith<_$WorkoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlannedExercise _$PlannedExerciseFromJson(Map<String, dynamic> json) {
  return _PlannedExercise.fromJson(json);
}

/// @nodoc
mixin _$PlannedExercise {
  /// Reference to exercise in the library
  String get exerciseId => throw _privateConstructorUsedError;

  /// Exercise name (denormalized for display)
  String get exerciseName => throw _privateConstructorUsedError;

  /// Order in the workout
  int get order => throw _privateConstructorUsedError;

  /// Target number of sets
  int get targetSets => throw _privateConstructorUsedError;

  /// Target rep range (e.g., "8-12")
  String get targetReps => throw _privateConstructorUsedError;

  /// Recommended rest time in seconds
  int get restSeconds => throw _privateConstructorUsedError;

  /// Optional notes from AI coach
  String? get notes => throw _privateConstructorUsedError;

  /// Whether this exercise was swapped from original
  bool get wasSwapped => throw _privateConstructorUsedError;

  /// Original exercise ID if swapped
  String? get originalExerciseId => throw _privateConstructorUsedError;

  /// Completion status: 'pending', 'completed', 'skipped'
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlannedExerciseCopyWith<PlannedExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedExerciseCopyWith<$Res> {
  factory $PlannedExerciseCopyWith(
          PlannedExercise value, $Res Function(PlannedExercise) then) =
      _$PlannedExerciseCopyWithImpl<$Res, PlannedExercise>;
  @useResult
  $Res call(
      {String exerciseId,
      String exerciseName,
      int order,
      int targetSets,
      String targetReps,
      int restSeconds,
      String? notes,
      bool wasSwapped,
      String? originalExerciseId,
      String status});
}

/// @nodoc
class _$PlannedExerciseCopyWithImpl<$Res, $Val extends PlannedExercise>
    implements $PlannedExerciseCopyWith<$Res> {
  _$PlannedExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? wasSwapped = null,
    Object? originalExerciseId = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as String,
      restSeconds: null == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasSwapped: null == wasSwapped
          ? _value.wasSwapped
          : wasSwapped // ignore: cast_nullable_to_non_nullable
              as bool,
      originalExerciseId: freezed == originalExerciseId
          ? _value.originalExerciseId
          : originalExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedExerciseImplCopyWith<$Res>
    implements $PlannedExerciseCopyWith<$Res> {
  factory _$$PlannedExerciseImplCopyWith(_$PlannedExerciseImpl value,
          $Res Function(_$PlannedExerciseImpl) then) =
      __$$PlannedExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String exerciseId,
      String exerciseName,
      int order,
      int targetSets,
      String targetReps,
      int restSeconds,
      String? notes,
      bool wasSwapped,
      String? originalExerciseId,
      String status});
}

/// @nodoc
class __$$PlannedExerciseImplCopyWithImpl<$Res>
    extends _$PlannedExerciseCopyWithImpl<$Res, _$PlannedExerciseImpl>
    implements _$$PlannedExerciseImplCopyWith<$Res> {
  __$$PlannedExerciseImplCopyWithImpl(
      _$PlannedExerciseImpl _value, $Res Function(_$PlannedExerciseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? targetSets = null,
    Object? targetReps = null,
    Object? restSeconds = null,
    Object? notes = freezed,
    Object? wasSwapped = null,
    Object? originalExerciseId = freezed,
    Object? status = null,
  }) {
    return _then(_$PlannedExerciseImpl(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      targetSets: null == targetSets
          ? _value.targetSets
          : targetSets // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as String,
      restSeconds: null == restSeconds
          ? _value.restSeconds
          : restSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      wasSwapped: null == wasSwapped
          ? _value.wasSwapped
          : wasSwapped // ignore: cast_nullable_to_non_nullable
              as bool,
      originalExerciseId: freezed == originalExerciseId
          ? _value.originalExerciseId
          : originalExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedExerciseImpl implements _PlannedExercise {
  const _$PlannedExerciseImpl(
      {required this.exerciseId,
      required this.exerciseName,
      required this.order,
      required this.targetSets,
      required this.targetReps,
      this.restSeconds = 90,
      this.notes,
      this.wasSwapped = false,
      this.originalExerciseId,
      this.status = 'pending'});

  factory _$PlannedExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedExerciseImplFromJson(json);

  /// Reference to exercise in the library
  @override
  final String exerciseId;

  /// Exercise name (denormalized for display)
  @override
  final String exerciseName;

  /// Order in the workout
  @override
  final int order;

  /// Target number of sets
  @override
  final int targetSets;

  /// Target rep range (e.g., "8-12")
  @override
  final String targetReps;

  /// Recommended rest time in seconds
  @override
  @JsonKey()
  final int restSeconds;

  /// Optional notes from AI coach
  @override
  final String? notes;

  /// Whether this exercise was swapped from original
  @override
  @JsonKey()
  final bool wasSwapped;

  /// Original exercise ID if swapped
  @override
  final String? originalExerciseId;

  /// Completion status: 'pending', 'completed', 'skipped'
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'PlannedExercise(exerciseId: $exerciseId, exerciseName: $exerciseName, order: $order, targetSets: $targetSets, targetReps: $targetReps, restSeconds: $restSeconds, notes: $notes, wasSwapped: $wasSwapped, originalExerciseId: $originalExerciseId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedExerciseImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.targetSets, targetSets) ||
                other.targetSets == targetSets) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.restSeconds, restSeconds) ||
                other.restSeconds == restSeconds) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.wasSwapped, wasSwapped) ||
                other.wasSwapped == wasSwapped) &&
            (identical(other.originalExerciseId, originalExerciseId) ||
                other.originalExerciseId == originalExerciseId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      exerciseId,
      exerciseName,
      order,
      targetSets,
      targetReps,
      restSeconds,
      notes,
      wasSwapped,
      originalExerciseId,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedExerciseImplCopyWith<_$PlannedExerciseImpl> get copyWith =>
      __$$PlannedExerciseImplCopyWithImpl<_$PlannedExerciseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedExerciseImplToJson(
      this,
    );
  }
}

abstract class _PlannedExercise implements PlannedExercise {
  const factory _PlannedExercise(
      {required final String exerciseId,
      required final String exerciseName,
      required final int order,
      required final int targetSets,
      required final String targetReps,
      final int restSeconds,
      final String? notes,
      final bool wasSwapped,
      final String? originalExerciseId,
      final String status}) = _$PlannedExerciseImpl;

  factory _PlannedExercise.fromJson(Map<String, dynamic> json) =
      _$PlannedExerciseImpl.fromJson;

  @override

  /// Reference to exercise in the library
  String get exerciseId;
  @override

  /// Exercise name (denormalized for display)
  String get exerciseName;
  @override

  /// Order in the workout
  int get order;
  @override

  /// Target number of sets
  int get targetSets;
  @override

  /// Target rep range (e.g., "8-12")
  String get targetReps;
  @override

  /// Recommended rest time in seconds
  int get restSeconds;
  @override

  /// Optional notes from AI coach
  String? get notes;
  @override

  /// Whether this exercise was swapped from original
  bool get wasSwapped;
  @override

  /// Original exercise ID if swapped
  String? get originalExerciseId;
  @override

  /// Completion status: 'pending', 'completed', 'skipped'
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$PlannedExerciseImplCopyWith<_$PlannedExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
