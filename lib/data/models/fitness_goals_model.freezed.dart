// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fitness_goals_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FitnessGoals _$FitnessGoalsFromJson(Map<String, dynamic> json) {
  return _FitnessGoals.fromJson(json);
}

/// @nodoc
mixin _$FitnessGoals {
  /// Primary goal: 'general_fitness', 'muscle_building', 'weight_loss', 'strength'
  String get primaryGoal => throw _privateConstructorUsedError;

  /// Experience level: 'beginner', 'intermediate', 'advanced'
  String get experienceLevel => throw _privateConstructorUsedError;

  /// Target workout days per week (1-7)
  int get workoutDaysPerWeek => throw _privateConstructorUsedError;

  /// Preferred workout duration in minutes
  int get preferredDurationMinutes => throw _privateConstructorUsedError;

  /// Balance preferences (0.0 to 1.0 each, should sum to 1.0)
  double get strengthFocus => throw _privateConstructorUsedError;
  double get cardioFocus => throw _privateConstructorUsedError;
  double get mobilityFocus => throw _privateConstructorUsedError;

  /// Any injuries or areas to avoid
  List<String> get injuryNotes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FitnessGoalsCopyWith<FitnessGoals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessGoalsCopyWith<$Res> {
  factory $FitnessGoalsCopyWith(
          FitnessGoals value, $Res Function(FitnessGoals) then) =
      _$FitnessGoalsCopyWithImpl<$Res, FitnessGoals>;
  @useResult
  $Res call(
      {String primaryGoal,
      String experienceLevel,
      int workoutDaysPerWeek,
      int preferredDurationMinutes,
      double strengthFocus,
      double cardioFocus,
      double mobilityFocus,
      List<String> injuryNotes});
}

/// @nodoc
class _$FitnessGoalsCopyWithImpl<$Res, $Val extends FitnessGoals>
    implements $FitnessGoalsCopyWith<$Res> {
  _$FitnessGoalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGoal = null,
    Object? experienceLevel = null,
    Object? workoutDaysPerWeek = null,
    Object? preferredDurationMinutes = null,
    Object? strengthFocus = null,
    Object? cardioFocus = null,
    Object? mobilityFocus = null,
    Object? injuryNotes = null,
  }) {
    return _then(_value.copyWith(
      primaryGoal: null == primaryGoal
          ? _value.primaryGoal
          : primaryGoal // ignore: cast_nullable_to_non_nullable
              as String,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as String,
      workoutDaysPerWeek: null == workoutDaysPerWeek
          ? _value.workoutDaysPerWeek
          : workoutDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      preferredDurationMinutes: null == preferredDurationMinutes
          ? _value.preferredDurationMinutes
          : preferredDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      strengthFocus: null == strengthFocus
          ? _value.strengthFocus
          : strengthFocus // ignore: cast_nullable_to_non_nullable
              as double,
      cardioFocus: null == cardioFocus
          ? _value.cardioFocus
          : cardioFocus // ignore: cast_nullable_to_non_nullable
              as double,
      mobilityFocus: null == mobilityFocus
          ? _value.mobilityFocus
          : mobilityFocus // ignore: cast_nullable_to_non_nullable
              as double,
      injuryNotes: null == injuryNotes
          ? _value.injuryNotes
          : injuryNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FitnessGoalsImplCopyWith<$Res>
    implements $FitnessGoalsCopyWith<$Res> {
  factory _$$FitnessGoalsImplCopyWith(
          _$FitnessGoalsImpl value, $Res Function(_$FitnessGoalsImpl) then) =
      __$$FitnessGoalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String primaryGoal,
      String experienceLevel,
      int workoutDaysPerWeek,
      int preferredDurationMinutes,
      double strengthFocus,
      double cardioFocus,
      double mobilityFocus,
      List<String> injuryNotes});
}

/// @nodoc
class __$$FitnessGoalsImplCopyWithImpl<$Res>
    extends _$FitnessGoalsCopyWithImpl<$Res, _$FitnessGoalsImpl>
    implements _$$FitnessGoalsImplCopyWith<$Res> {
  __$$FitnessGoalsImplCopyWithImpl(
      _$FitnessGoalsImpl _value, $Res Function(_$FitnessGoalsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryGoal = null,
    Object? experienceLevel = null,
    Object? workoutDaysPerWeek = null,
    Object? preferredDurationMinutes = null,
    Object? strengthFocus = null,
    Object? cardioFocus = null,
    Object? mobilityFocus = null,
    Object? injuryNotes = null,
  }) {
    return _then(_$FitnessGoalsImpl(
      primaryGoal: null == primaryGoal
          ? _value.primaryGoal
          : primaryGoal // ignore: cast_nullable_to_non_nullable
              as String,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as String,
      workoutDaysPerWeek: null == workoutDaysPerWeek
          ? _value.workoutDaysPerWeek
          : workoutDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      preferredDurationMinutes: null == preferredDurationMinutes
          ? _value.preferredDurationMinutes
          : preferredDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      strengthFocus: null == strengthFocus
          ? _value.strengthFocus
          : strengthFocus // ignore: cast_nullable_to_non_nullable
              as double,
      cardioFocus: null == cardioFocus
          ? _value.cardioFocus
          : cardioFocus // ignore: cast_nullable_to_non_nullable
              as double,
      mobilityFocus: null == mobilityFocus
          ? _value.mobilityFocus
          : mobilityFocus // ignore: cast_nullable_to_non_nullable
              as double,
      injuryNotes: null == injuryNotes
          ? _value._injuryNotes
          : injuryNotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FitnessGoalsImpl implements _FitnessGoals {
  const _$FitnessGoalsImpl(
      {this.primaryGoal = 'general_fitness',
      this.experienceLevel = 'beginner',
      this.workoutDaysPerWeek = 4,
      this.preferredDurationMinutes = 45,
      this.strengthFocus = 0.5,
      this.cardioFocus = 0.3,
      this.mobilityFocus = 0.2,
      final List<String> injuryNotes = const []})
      : _injuryNotes = injuryNotes;

  factory _$FitnessGoalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FitnessGoalsImplFromJson(json);

  /// Primary goal: 'general_fitness', 'muscle_building', 'weight_loss', 'strength'
  @override
  @JsonKey()
  final String primaryGoal;

  /// Experience level: 'beginner', 'intermediate', 'advanced'
  @override
  @JsonKey()
  final String experienceLevel;

  /// Target workout days per week (1-7)
  @override
  @JsonKey()
  final int workoutDaysPerWeek;

  /// Preferred workout duration in minutes
  @override
  @JsonKey()
  final int preferredDurationMinutes;

  /// Balance preferences (0.0 to 1.0 each, should sum to 1.0)
  @override
  @JsonKey()
  final double strengthFocus;
  @override
  @JsonKey()
  final double cardioFocus;
  @override
  @JsonKey()
  final double mobilityFocus;

  /// Any injuries or areas to avoid
  final List<String> _injuryNotes;

  /// Any injuries or areas to avoid
  @override
  @JsonKey()
  List<String> get injuryNotes {
    if (_injuryNotes is EqualUnmodifiableListView) return _injuryNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_injuryNotes);
  }

  @override
  String toString() {
    return 'FitnessGoals(primaryGoal: $primaryGoal, experienceLevel: $experienceLevel, workoutDaysPerWeek: $workoutDaysPerWeek, preferredDurationMinutes: $preferredDurationMinutes, strengthFocus: $strengthFocus, cardioFocus: $cardioFocus, mobilityFocus: $mobilityFocus, injuryNotes: $injuryNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessGoalsImpl &&
            (identical(other.primaryGoal, primaryGoal) ||
                other.primaryGoal == primaryGoal) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel) &&
            (identical(other.workoutDaysPerWeek, workoutDaysPerWeek) ||
                other.workoutDaysPerWeek == workoutDaysPerWeek) &&
            (identical(
                    other.preferredDurationMinutes, preferredDurationMinutes) ||
                other.preferredDurationMinutes == preferredDurationMinutes) &&
            (identical(other.strengthFocus, strengthFocus) ||
                other.strengthFocus == strengthFocus) &&
            (identical(other.cardioFocus, cardioFocus) ||
                other.cardioFocus == cardioFocus) &&
            (identical(other.mobilityFocus, mobilityFocus) ||
                other.mobilityFocus == mobilityFocus) &&
            const DeepCollectionEquality()
                .equals(other._injuryNotes, _injuryNotes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      primaryGoal,
      experienceLevel,
      workoutDaysPerWeek,
      preferredDurationMinutes,
      strengthFocus,
      cardioFocus,
      mobilityFocus,
      const DeepCollectionEquality().hash(_injuryNotes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessGoalsImplCopyWith<_$FitnessGoalsImpl> get copyWith =>
      __$$FitnessGoalsImplCopyWithImpl<_$FitnessGoalsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FitnessGoalsImplToJson(
      this,
    );
  }
}

abstract class _FitnessGoals implements FitnessGoals {
  const factory _FitnessGoals(
      {final String primaryGoal,
      final String experienceLevel,
      final int workoutDaysPerWeek,
      final int preferredDurationMinutes,
      final double strengthFocus,
      final double cardioFocus,
      final double mobilityFocus,
      final List<String> injuryNotes}) = _$FitnessGoalsImpl;

  factory _FitnessGoals.fromJson(Map<String, dynamic> json) =
      _$FitnessGoalsImpl.fromJson;

  @override

  /// Primary goal: 'general_fitness', 'muscle_building', 'weight_loss', 'strength'
  String get primaryGoal;
  @override

  /// Experience level: 'beginner', 'intermediate', 'advanced'
  String get experienceLevel;
  @override

  /// Target workout days per week (1-7)
  int get workoutDaysPerWeek;
  @override

  /// Preferred workout duration in minutes
  int get preferredDurationMinutes;
  @override

  /// Balance preferences (0.0 to 1.0 each, should sum to 1.0)
  double get strengthFocus;
  @override
  double get cardioFocus;
  @override
  double get mobilityFocus;
  @override

  /// Any injuries or areas to avoid
  List<String> get injuryNotes;
  @override
  @JsonKey(ignore: true)
  _$$FitnessGoalsImplCopyWith<_$FitnessGoalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
