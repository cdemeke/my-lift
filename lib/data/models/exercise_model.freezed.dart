// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Exercise name
  String get name => throw _privateConstructorUsedError;

  /// Detailed description and instructions
  String get description => throw _privateConstructorUsedError;

  /// Primary muscle group targeted
  String get primaryMuscleGroup => throw _privateConstructorUsedError;

  /// Secondary muscle groups worked
  List<String> get secondaryMuscleGroups => throw _privateConstructorUsedError;

  /// Required equipment IDs (empty for bodyweight)
  List<String> get requiredEquipment => throw _privateConstructorUsedError;

  /// Exercise type: 'compound', 'isolation', 'cardio', 'mobility'
  String get exerciseType => throw _privateConstructorUsedError;

  /// Difficulty: 'beginner', 'intermediate', 'advanced'
  String get difficulty => throw _privateConstructorUsedError;

  /// Curated YouTube video ID (if available)
  String? get youtubeVideoId => throw _privateConstructorUsedError;

  /// Search keywords for AI video lookup fallback
  List<String> get videoSearchKeywords => throw _privateConstructorUsedError;

  /// Common mistakes to avoid
  List<String> get commonMistakes => throw _privateConstructorUsedError;

  /// Tips for proper form
  List<String> get formTips => throw _privateConstructorUsedError;

  /// Alternative exercise IDs
  List<String> get alternativeExerciseIds => throw _privateConstructorUsedError;

  /// Whether this is a bodyweight exercise
  bool get isBodyweight => throw _privateConstructorUsedError;

  /// Sort order within muscle group
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String primaryMuscleGroup,
      List<String> secondaryMuscleGroups,
      List<String> requiredEquipment,
      String exerciseType,
      String difficulty,
      String? youtubeVideoId,
      List<String> videoSearchKeywords,
      List<String> commonMistakes,
      List<String> formTips,
      List<String> alternativeExerciseIds,
      bool isBodyweight,
      int sortOrder});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? primaryMuscleGroup = null,
    Object? secondaryMuscleGroups = null,
    Object? requiredEquipment = null,
    Object? exerciseType = null,
    Object? difficulty = null,
    Object? youtubeVideoId = freezed,
    Object? videoSearchKeywords = null,
    Object? commonMistakes = null,
    Object? formTips = null,
    Object? alternativeExerciseIds = null,
    Object? isBodyweight = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _value.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _value.secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requiredEquipment: null == requiredEquipment
          ? _value.requiredEquipment
          : requiredEquipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exerciseType: null == exerciseType
          ? _value.exerciseType
          : exerciseType // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeVideoId: freezed == youtubeVideoId
          ? _value.youtubeVideoId
          : youtubeVideoId // ignore: cast_nullable_to_non_nullable
              as String?,
      videoSearchKeywords: null == videoSearchKeywords
          ? _value.videoSearchKeywords
          : videoSearchKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commonMistakes: null == commonMistakes
          ? _value.commonMistakes
          : commonMistakes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      formTips: null == formTips
          ? _value.formTips
          : formTips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alternativeExerciseIds: null == alternativeExerciseIds
          ? _value.alternativeExerciseIds
          : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBodyweight: null == isBodyweight
          ? _value.isBodyweight
          : isBodyweight // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String primaryMuscleGroup,
      List<String> secondaryMuscleGroups,
      List<String> requiredEquipment,
      String exerciseType,
      String difficulty,
      String? youtubeVideoId,
      List<String> videoSearchKeywords,
      List<String> commonMistakes,
      List<String> formTips,
      List<String> alternativeExerciseIds,
      bool isBodyweight,
      int sortOrder});
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? primaryMuscleGroup = null,
    Object? secondaryMuscleGroups = null,
    Object? requiredEquipment = null,
    Object? exerciseType = null,
    Object? difficulty = null,
    Object? youtubeVideoId = freezed,
    Object? videoSearchKeywords = null,
    Object? commonMistakes = null,
    Object? formTips = null,
    Object? alternativeExerciseIds = null,
    Object? isBodyweight = null,
    Object? sortOrder = null,
  }) {
    return _then(_$ExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      primaryMuscleGroup: null == primaryMuscleGroup
          ? _value.primaryMuscleGroup
          : primaryMuscleGroup // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryMuscleGroups: null == secondaryMuscleGroups
          ? _value._secondaryMuscleGroups
          : secondaryMuscleGroups // ignore: cast_nullable_to_non_nullable
              as List<String>,
      requiredEquipment: null == requiredEquipment
          ? _value._requiredEquipment
          : requiredEquipment // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exerciseType: null == exerciseType
          ? _value.exerciseType
          : exerciseType // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
      youtubeVideoId: freezed == youtubeVideoId
          ? _value.youtubeVideoId
          : youtubeVideoId // ignore: cast_nullable_to_non_nullable
              as String?,
      videoSearchKeywords: null == videoSearchKeywords
          ? _value._videoSearchKeywords
          : videoSearchKeywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commonMistakes: null == commonMistakes
          ? _value._commonMistakes
          : commonMistakes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      formTips: null == formTips
          ? _value._formTips
          : formTips // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alternativeExerciseIds: null == alternativeExerciseIds
          ? _value._alternativeExerciseIds
          : alternativeExerciseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBodyweight: null == isBodyweight
          ? _value.isBodyweight
          : isBodyweight // ignore: cast_nullable_to_non_nullable
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
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.primaryMuscleGroup,
      final List<String> secondaryMuscleGroups = const [],
      final List<String> requiredEquipment = const [],
      required this.exerciseType,
      required this.difficulty,
      this.youtubeVideoId,
      final List<String> videoSearchKeywords = const [],
      final List<String> commonMistakes = const [],
      final List<String> formTips = const [],
      final List<String> alternativeExerciseIds = const [],
      this.isBodyweight = false,
      this.sortOrder = 0})
      : _secondaryMuscleGroups = secondaryMuscleGroups,
        _requiredEquipment = requiredEquipment,
        _videoSearchKeywords = videoSearchKeywords,
        _commonMistakes = commonMistakes,
        _formTips = formTips,
        _alternativeExerciseIds = alternativeExerciseIds;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Exercise name
  @override
  final String name;

  /// Detailed description and instructions
  @override
  final String description;

  /// Primary muscle group targeted
  @override
  final String primaryMuscleGroup;

  /// Secondary muscle groups worked
  final List<String> _secondaryMuscleGroups;

  /// Secondary muscle groups worked
  @override
  @JsonKey()
  List<String> get secondaryMuscleGroups {
    if (_secondaryMuscleGroups is EqualUnmodifiableListView)
      return _secondaryMuscleGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_secondaryMuscleGroups);
  }

  /// Required equipment IDs (empty for bodyweight)
  final List<String> _requiredEquipment;

  /// Required equipment IDs (empty for bodyweight)
  @override
  @JsonKey()
  List<String> get requiredEquipment {
    if (_requiredEquipment is EqualUnmodifiableListView)
      return _requiredEquipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredEquipment);
  }

  /// Exercise type: 'compound', 'isolation', 'cardio', 'mobility'
  @override
  final String exerciseType;

  /// Difficulty: 'beginner', 'intermediate', 'advanced'
  @override
  final String difficulty;

  /// Curated YouTube video ID (if available)
  @override
  final String? youtubeVideoId;

  /// Search keywords for AI video lookup fallback
  final List<String> _videoSearchKeywords;

  /// Search keywords for AI video lookup fallback
  @override
  @JsonKey()
  List<String> get videoSearchKeywords {
    if (_videoSearchKeywords is EqualUnmodifiableListView)
      return _videoSearchKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoSearchKeywords);
  }

  /// Common mistakes to avoid
  final List<String> _commonMistakes;

  /// Common mistakes to avoid
  @override
  @JsonKey()
  List<String> get commonMistakes {
    if (_commonMistakes is EqualUnmodifiableListView) return _commonMistakes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonMistakes);
  }

  /// Tips for proper form
  final List<String> _formTips;

  /// Tips for proper form
  @override
  @JsonKey()
  List<String> get formTips {
    if (_formTips is EqualUnmodifiableListView) return _formTips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_formTips);
  }

  /// Alternative exercise IDs
  final List<String> _alternativeExerciseIds;

  /// Alternative exercise IDs
  @override
  @JsonKey()
  List<String> get alternativeExerciseIds {
    if (_alternativeExerciseIds is EqualUnmodifiableListView)
      return _alternativeExerciseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternativeExerciseIds);
  }

  /// Whether this is a bodyweight exercise
  @override
  @JsonKey()
  final bool isBodyweight;

  /// Sort order within muscle group
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'Exercise(id: $id, name: $name, description: $description, primaryMuscleGroup: $primaryMuscleGroup, secondaryMuscleGroups: $secondaryMuscleGroups, requiredEquipment: $requiredEquipment, exerciseType: $exerciseType, difficulty: $difficulty, youtubeVideoId: $youtubeVideoId, videoSearchKeywords: $videoSearchKeywords, commonMistakes: $commonMistakes, formTips: $formTips, alternativeExerciseIds: $alternativeExerciseIds, isBodyweight: $isBodyweight, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.primaryMuscleGroup, primaryMuscleGroup) ||
                other.primaryMuscleGroup == primaryMuscleGroup) &&
            const DeepCollectionEquality()
                .equals(other._secondaryMuscleGroups, _secondaryMuscleGroups) &&
            const DeepCollectionEquality()
                .equals(other._requiredEquipment, _requiredEquipment) &&
            (identical(other.exerciseType, exerciseType) ||
                other.exerciseType == exerciseType) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.youtubeVideoId, youtubeVideoId) ||
                other.youtubeVideoId == youtubeVideoId) &&
            const DeepCollectionEquality()
                .equals(other._videoSearchKeywords, _videoSearchKeywords) &&
            const DeepCollectionEquality()
                .equals(other._commonMistakes, _commonMistakes) &&
            const DeepCollectionEquality().equals(other._formTips, _formTips) &&
            const DeepCollectionEquality().equals(
                other._alternativeExerciseIds, _alternativeExerciseIds) &&
            (identical(other.isBodyweight, isBodyweight) ||
                other.isBodyweight == isBodyweight) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      primaryMuscleGroup,
      const DeepCollectionEquality().hash(_secondaryMuscleGroups),
      const DeepCollectionEquality().hash(_requiredEquipment),
      exerciseType,
      difficulty,
      youtubeVideoId,
      const DeepCollectionEquality().hash(_videoSearchKeywords),
      const DeepCollectionEquality().hash(_commonMistakes),
      const DeepCollectionEquality().hash(_formTips),
      const DeepCollectionEquality().hash(_alternativeExerciseIds),
      isBodyweight,
      sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise(
      {required final String id,
      required final String name,
      required final String description,
      required final String primaryMuscleGroup,
      final List<String> secondaryMuscleGroups,
      final List<String> requiredEquipment,
      required final String exerciseType,
      required final String difficulty,
      final String? youtubeVideoId,
      final List<String> videoSearchKeywords,
      final List<String> commonMistakes,
      final List<String> formTips,
      final List<String> alternativeExerciseIds,
      final bool isBodyweight,
      final int sortOrder}) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Exercise name
  String get name;
  @override

  /// Detailed description and instructions
  String get description;
  @override

  /// Primary muscle group targeted
  String get primaryMuscleGroup;
  @override

  /// Secondary muscle groups worked
  List<String> get secondaryMuscleGroups;
  @override

  /// Required equipment IDs (empty for bodyweight)
  List<String> get requiredEquipment;
  @override

  /// Exercise type: 'compound', 'isolation', 'cardio', 'mobility'
  String get exerciseType;
  @override

  /// Difficulty: 'beginner', 'intermediate', 'advanced'
  String get difficulty;
  @override

  /// Curated YouTube video ID (if available)
  String? get youtubeVideoId;
  @override

  /// Search keywords for AI video lookup fallback
  List<String> get videoSearchKeywords;
  @override

  /// Common mistakes to avoid
  List<String> get commonMistakes;
  @override

  /// Tips for proper form
  List<String> get formTips;
  @override

  /// Alternative exercise IDs
  List<String> get alternativeExerciseIds;
  @override

  /// Whether this is a bodyweight exercise
  bool get isBodyweight;
  @override

  /// Sort order within muscle group
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
