// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExerciseLog _$ExerciseLogFromJson(Map<String, dynamic> json) {
  return _ExerciseLog.fromJson(json);
}

/// @nodoc
mixin _$ExerciseLog {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Reference to the workout this belongs to
  String get workoutId => throw _privateConstructorUsedError;

  /// Reference to the exercise performed
  String get exerciseId => throw _privateConstructorUsedError;

  /// Exercise name (denormalized for display)
  String get exerciseName => throw _privateConstructorUsedError;

  /// List of completed sets
  List<SetLog> get sets => throw _privateConstructorUsedError;

  /// When this exercise was logged
  @TimestampConverter()
  DateTime get loggedAt => throw _privateConstructorUsedError;

  /// Optional notes from user
  String? get userNotes => throw _privateConstructorUsedError;

  /// Whether logged in real-time or after workout
  bool get loggedRealTime => throw _privateConstructorUsedError;

  /// Sync status for offline support: 'synced', 'pending', 'failed'
  String get syncStatus => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExerciseLogCopyWith<ExerciseLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseLogCopyWith<$Res> {
  factory $ExerciseLogCopyWith(
          ExerciseLog value, $Res Function(ExerciseLog) then) =
      _$ExerciseLogCopyWithImpl<$Res, ExerciseLog>;
  @useResult
  $Res call(
      {String id,
      String workoutId,
      String exerciseId,
      String exerciseName,
      List<SetLog> sets,
      @TimestampConverter() DateTime loggedAt,
      String? userNotes,
      bool loggedRealTime,
      String syncStatus});
}

/// @nodoc
class _$ExerciseLogCopyWithImpl<$Res, $Val extends ExerciseLog>
    implements $ExerciseLogCopyWith<$Res> {
  _$ExerciseLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? exerciseId = null,
    Object? exerciseName = null,
    Object? sets = null,
    Object? loggedAt = null,
    Object? userNotes = freezed,
    Object? loggedRealTime = null,
    Object? syncStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<SetLog>,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      loggedRealTime: null == loggedRealTime
          ? _value.loggedRealTime
          : loggedRealTime // ignore: cast_nullable_to_non_nullable
              as bool,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseLogImplCopyWith<$Res>
    implements $ExerciseLogCopyWith<$Res> {
  factory _$$ExerciseLogImplCopyWith(
          _$ExerciseLogImpl value, $Res Function(_$ExerciseLogImpl) then) =
      __$$ExerciseLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workoutId,
      String exerciseId,
      String exerciseName,
      List<SetLog> sets,
      @TimestampConverter() DateTime loggedAt,
      String? userNotes,
      bool loggedRealTime,
      String syncStatus});
}

/// @nodoc
class __$$ExerciseLogImplCopyWithImpl<$Res>
    extends _$ExerciseLogCopyWithImpl<$Res, _$ExerciseLogImpl>
    implements _$$ExerciseLogImplCopyWith<$Res> {
  __$$ExerciseLogImplCopyWithImpl(
      _$ExerciseLogImpl _value, $Res Function(_$ExerciseLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutId = null,
    Object? exerciseId = null,
    Object? exerciseName = null,
    Object? sets = null,
    Object? loggedAt = null,
    Object? userNotes = freezed,
    Object? loggedRealTime = null,
    Object? syncStatus = null,
  }) {
    return _then(_$ExerciseLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workoutId: null == workoutId
          ? _value.workoutId
          : workoutId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as String,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<SetLog>,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userNotes: freezed == userNotes
          ? _value.userNotes
          : userNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      loggedRealTime: null == loggedRealTime
          ? _value.loggedRealTime
          : loggedRealTime // ignore: cast_nullable_to_non_nullable
              as bool,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseLogImpl implements _ExerciseLog {
  const _$ExerciseLogImpl(
      {required this.id,
      required this.workoutId,
      required this.exerciseId,
      required this.exerciseName,
      final List<SetLog> sets = const [],
      @TimestampConverter() required this.loggedAt,
      this.userNotes,
      this.loggedRealTime = false,
      this.syncStatus = 'synced'})
      : _sets = sets;

  factory _$ExerciseLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseLogImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Reference to the workout this belongs to
  @override
  final String workoutId;

  /// Reference to the exercise performed
  @override
  final String exerciseId;

  /// Exercise name (denormalized for display)
  @override
  final String exerciseName;

  /// List of completed sets
  final List<SetLog> _sets;

  /// List of completed sets
  @override
  @JsonKey()
  List<SetLog> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  /// When this exercise was logged
  @override
  @TimestampConverter()
  final DateTime loggedAt;

  /// Optional notes from user
  @override
  final String? userNotes;

  /// Whether logged in real-time or after workout
  @override
  @JsonKey()
  final bool loggedRealTime;

  /// Sync status for offline support: 'synced', 'pending', 'failed'
  @override
  @JsonKey()
  final String syncStatus;

  @override
  String toString() {
    return 'ExerciseLog(id: $id, workoutId: $workoutId, exerciseId: $exerciseId, exerciseName: $exerciseName, sets: $sets, loggedAt: $loggedAt, userNotes: $userNotes, loggedRealTime: $loggedRealTime, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutId, workoutId) ||
                other.workoutId == workoutId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.userNotes, userNotes) ||
                other.userNotes == userNotes) &&
            (identical(other.loggedRealTime, loggedRealTime) ||
                other.loggedRealTime == loggedRealTime) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      workoutId,
      exerciseId,
      exerciseName,
      const DeepCollectionEquality().hash(_sets),
      loggedAt,
      userNotes,
      loggedRealTime,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      __$$ExerciseLogImplCopyWithImpl<_$ExerciseLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseLogImplToJson(
      this,
    );
  }
}

abstract class _ExerciseLog implements ExerciseLog {
  const factory _ExerciseLog(
      {required final String id,
      required final String workoutId,
      required final String exerciseId,
      required final String exerciseName,
      final List<SetLog> sets,
      @TimestampConverter() required final DateTime loggedAt,
      final String? userNotes,
      final bool loggedRealTime,
      final String syncStatus}) = _$ExerciseLogImpl;

  factory _ExerciseLog.fromJson(Map<String, dynamic> json) =
      _$ExerciseLogImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Reference to the workout this belongs to
  String get workoutId;
  @override

  /// Reference to the exercise performed
  String get exerciseId;
  @override

  /// Exercise name (denormalized for display)
  String get exerciseName;
  @override

  /// List of completed sets
  List<SetLog> get sets;
  @override

  /// When this exercise was logged
  @TimestampConverter()
  DateTime get loggedAt;
  @override

  /// Optional notes from user
  String? get userNotes;
  @override

  /// Whether logged in real-time or after workout
  bool get loggedRealTime;
  @override

  /// Sync status for offline support: 'synced', 'pending', 'failed'
  String get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseLogImplCopyWith<_$ExerciseLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SetLog _$SetLogFromJson(Map<String, dynamic> json) {
  return _SetLog.fromJson(json);
}

/// @nodoc
mixin _$SetLog {
  /// Set number (1-indexed)
  int get setNumber => throw _privateConstructorUsedError;

  /// Repetitions completed
  int get reps => throw _privateConstructorUsedError;

  /// Weight used (0 for bodyweight)
  double get weight => throw _privateConstructorUsedError;

  /// Weight unit: 'lbs' or 'kg'
  String get weightUnit => throw _privateConstructorUsedError;

  /// Whether this was a warmup set
  bool get isWarmup => throw _privateConstructorUsedError;

  /// Whether this was a drop set
  bool get isDropSet => throw _privateConstructorUsedError;

  /// Whether this was to failure
  bool get isToFailure => throw _privateConstructorUsedError;

  /// Perceived difficulty: 'easy', 'moderate', 'hard', 'failure'
  String? get difficulty => throw _privateConstructorUsedError;

  /// Time of completion (for tracking rest times)
  @NullableTimestampConverter()
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SetLogCopyWith<SetLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetLogCopyWith<$Res> {
  factory $SetLogCopyWith(SetLog value, $Res Function(SetLog) then) =
      _$SetLogCopyWithImpl<$Res, SetLog>;
  @useResult
  $Res call(
      {int setNumber,
      int reps,
      double weight,
      String weightUnit,
      bool isWarmup,
      bool isDropSet,
      bool isToFailure,
      String? difficulty,
      @NullableTimestampConverter() DateTime? completedAt});
}

/// @nodoc
class _$SetLogCopyWithImpl<$Res, $Val extends SetLog>
    implements $SetLogCopyWith<$Res> {
  _$SetLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? reps = null,
    Object? weight = null,
    Object? weightUnit = null,
    Object? isWarmup = null,
    Object? isDropSet = null,
    Object? isToFailure = null,
    Object? difficulty = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      weightUnit: null == weightUnit
          ? _value.weightUnit
          : weightUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isWarmup: null == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool,
      isDropSet: null == isDropSet
          ? _value.isDropSet
          : isDropSet // ignore: cast_nullable_to_non_nullable
              as bool,
      isToFailure: null == isToFailure
          ? _value.isToFailure
          : isToFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetLogImplCopyWith<$Res> implements $SetLogCopyWith<$Res> {
  factory _$$SetLogImplCopyWith(
          _$SetLogImpl value, $Res Function(_$SetLogImpl) then) =
      __$$SetLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int setNumber,
      int reps,
      double weight,
      String weightUnit,
      bool isWarmup,
      bool isDropSet,
      bool isToFailure,
      String? difficulty,
      @NullableTimestampConverter() DateTime? completedAt});
}

/// @nodoc
class __$$SetLogImplCopyWithImpl<$Res>
    extends _$SetLogCopyWithImpl<$Res, _$SetLogImpl>
    implements _$$SetLogImplCopyWith<$Res> {
  __$$SetLogImplCopyWithImpl(
      _$SetLogImpl _value, $Res Function(_$SetLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? setNumber = null,
    Object? reps = null,
    Object? weight = null,
    Object? weightUnit = null,
    Object? isWarmup = null,
    Object? isDropSet = null,
    Object? isToFailure = null,
    Object? difficulty = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(_$SetLogImpl(
      setNumber: null == setNumber
          ? _value.setNumber
          : setNumber // ignore: cast_nullable_to_non_nullable
              as int,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      weightUnit: null == weightUnit
          ? _value.weightUnit
          : weightUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isWarmup: null == isWarmup
          ? _value.isWarmup
          : isWarmup // ignore: cast_nullable_to_non_nullable
              as bool,
      isDropSet: null == isDropSet
          ? _value.isDropSet
          : isDropSet // ignore: cast_nullable_to_non_nullable
              as bool,
      isToFailure: null == isToFailure
          ? _value.isToFailure
          : isToFailure // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: freezed == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetLogImpl implements _SetLog {
  const _$SetLogImpl(
      {required this.setNumber,
      required this.reps,
      required this.weight,
      this.weightUnit = 'lbs',
      this.isWarmup = false,
      this.isDropSet = false,
      this.isToFailure = false,
      this.difficulty,
      @NullableTimestampConverter() this.completedAt});

  factory _$SetLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetLogImplFromJson(json);

  /// Set number (1-indexed)
  @override
  final int setNumber;

  /// Repetitions completed
  @override
  final int reps;

  /// Weight used (0 for bodyweight)
  @override
  final double weight;

  /// Weight unit: 'lbs' or 'kg'
  @override
  @JsonKey()
  final String weightUnit;

  /// Whether this was a warmup set
  @override
  @JsonKey()
  final bool isWarmup;

  /// Whether this was a drop set
  @override
  @JsonKey()
  final bool isDropSet;

  /// Whether this was to failure
  @override
  @JsonKey()
  final bool isToFailure;

  /// Perceived difficulty: 'easy', 'moderate', 'hard', 'failure'
  @override
  final String? difficulty;

  /// Time of completion (for tracking rest times)
  @override
  @NullableTimestampConverter()
  final DateTime? completedAt;

  @override
  String toString() {
    return 'SetLog(setNumber: $setNumber, reps: $reps, weight: $weight, weightUnit: $weightUnit, isWarmup: $isWarmup, isDropSet: $isDropSet, isToFailure: $isToFailure, difficulty: $difficulty, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetLogImpl &&
            (identical(other.setNumber, setNumber) ||
                other.setNumber == setNumber) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit) &&
            (identical(other.isWarmup, isWarmup) ||
                other.isWarmup == isWarmup) &&
            (identical(other.isDropSet, isDropSet) ||
                other.isDropSet == isDropSet) &&
            (identical(other.isToFailure, isToFailure) ||
                other.isToFailure == isToFailure) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, setNumber, reps, weight,
      weightUnit, isWarmup, isDropSet, isToFailure, difficulty, completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SetLogImplCopyWith<_$SetLogImpl> get copyWith =>
      __$$SetLogImplCopyWithImpl<_$SetLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetLogImplToJson(
      this,
    );
  }
}

abstract class _SetLog implements SetLog {
  const factory _SetLog(
          {required final int setNumber,
          required final int reps,
          required final double weight,
          final String weightUnit,
          final bool isWarmup,
          final bool isDropSet,
          final bool isToFailure,
          final String? difficulty,
          @NullableTimestampConverter() final DateTime? completedAt}) =
      _$SetLogImpl;

  factory _SetLog.fromJson(Map<String, dynamic> json) = _$SetLogImpl.fromJson;

  @override

  /// Set number (1-indexed)
  int get setNumber;
  @override

  /// Repetitions completed
  int get reps;
  @override

  /// Weight used (0 for bodyweight)
  double get weight;
  @override

  /// Weight unit: 'lbs' or 'kg'
  String get weightUnit;
  @override

  /// Whether this was a warmup set
  bool get isWarmup;
  @override

  /// Whether this was a drop set
  bool get isDropSet;
  @override

  /// Whether this was to failure
  bool get isToFailure;
  @override

  /// Perceived difficulty: 'easy', 'moderate', 'hard', 'failure'
  String? get difficulty;
  @override

  /// Time of completion (for tracking rest times)
  @NullableTimestampConverter()
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$SetLogImplCopyWith<_$SetLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
