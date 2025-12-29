// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Message sender: 'user' or 'coach'
  String get role => throw _privateConstructorUsedError;

  /// Message content
  String get content => throw _privateConstructorUsedError;

  /// When the message was sent
  @TimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Context type: 'general', 'workout_check_in', 'exercise_help', 'motivation', 'swap_request'
  String get contextType => throw _privateConstructorUsedError;

  /// Related workout ID (if discussing specific workout)
  String? get relatedWorkoutId => throw _privateConstructorUsedError;

  /// Related exercise ID (if discussing specific exercise)
  String? get relatedExerciseId => throw _privateConstructorUsedError;

  /// Whether this message contains suggested actions
  bool get hasSuggestedActions => throw _privateConstructorUsedError;

  /// Suggested action buttons (JSON encoded)
  List<SuggestedAction> get suggestedActions =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @TimestampConverter() DateTime timestamp,
      String contextType,
      String? relatedWorkoutId,
      String? relatedExerciseId,
      bool hasSuggestedActions,
      List<SuggestedAction> suggestedActions});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? contextType = null,
    Object? relatedWorkoutId = freezed,
    Object? relatedExerciseId = freezed,
    Object? hasSuggestedActions = null,
    Object? suggestedActions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contextType: null == contextType
          ? _value.contextType
          : contextType // ignore: cast_nullable_to_non_nullable
              as String,
      relatedWorkoutId: freezed == relatedWorkoutId
          ? _value.relatedWorkoutId
          : relatedWorkoutId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedExerciseId: freezed == relatedExerciseId
          ? _value.relatedExerciseId
          : relatedExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSuggestedActions: null == hasSuggestedActions
          ? _value.hasSuggestedActions
          : hasSuggestedActions // ignore: cast_nullable_to_non_nullable
              as bool,
      suggestedActions: null == suggestedActions
          ? _value.suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<SuggestedAction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String role,
      String content,
      @TimestampConverter() DateTime timestamp,
      String contextType,
      String? relatedWorkoutId,
      String? relatedExerciseId,
      bool hasSuggestedActions,
      List<SuggestedAction> suggestedActions});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? contextType = null,
    Object? relatedWorkoutId = freezed,
    Object? relatedExerciseId = freezed,
    Object? hasSuggestedActions = null,
    Object? suggestedActions = null,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contextType: null == contextType
          ? _value.contextType
          : contextType // ignore: cast_nullable_to_non_nullable
              as String,
      relatedWorkoutId: freezed == relatedWorkoutId
          ? _value.relatedWorkoutId
          : relatedWorkoutId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedExerciseId: freezed == relatedExerciseId
          ? _value.relatedExerciseId
          : relatedExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSuggestedActions: null == hasSuggestedActions
          ? _value.hasSuggestedActions
          : hasSuggestedActions // ignore: cast_nullable_to_non_nullable
              as bool,
      suggestedActions: null == suggestedActions
          ? _value._suggestedActions
          : suggestedActions // ignore: cast_nullable_to_non_nullable
              as List<SuggestedAction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      @TimestampConverter() required this.timestamp,
      this.contextType = 'general',
      this.relatedWorkoutId,
      this.relatedExerciseId,
      this.hasSuggestedActions = false,
      final List<SuggestedAction> suggestedActions = const []})
      : _suggestedActions = suggestedActions;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Message sender: 'user' or 'coach'
  @override
  final String role;

  /// Message content
  @override
  final String content;

  /// When the message was sent
  @override
  @TimestampConverter()
  final DateTime timestamp;

  /// Context type: 'general', 'workout_check_in', 'exercise_help', 'motivation', 'swap_request'
  @override
  @JsonKey()
  final String contextType;

  /// Related workout ID (if discussing specific workout)
  @override
  final String? relatedWorkoutId;

  /// Related exercise ID (if discussing specific exercise)
  @override
  final String? relatedExerciseId;

  /// Whether this message contains suggested actions
  @override
  @JsonKey()
  final bool hasSuggestedActions;

  /// Suggested action buttons (JSON encoded)
  final List<SuggestedAction> _suggestedActions;

  /// Suggested action buttons (JSON encoded)
  @override
  @JsonKey()
  List<SuggestedAction> get suggestedActions {
    if (_suggestedActions is EqualUnmodifiableListView)
      return _suggestedActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedActions);
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, timestamp: $timestamp, contextType: $contextType, relatedWorkoutId: $relatedWorkoutId, relatedExerciseId: $relatedExerciseId, hasSuggestedActions: $hasSuggestedActions, suggestedActions: $suggestedActions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.contextType, contextType) ||
                other.contextType == contextType) &&
            (identical(other.relatedWorkoutId, relatedWorkoutId) ||
                other.relatedWorkoutId == relatedWorkoutId) &&
            (identical(other.relatedExerciseId, relatedExerciseId) ||
                other.relatedExerciseId == relatedExerciseId) &&
            (identical(other.hasSuggestedActions, hasSuggestedActions) ||
                other.hasSuggestedActions == hasSuggestedActions) &&
            const DeepCollectionEquality()
                .equals(other._suggestedActions, _suggestedActions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      content,
      timestamp,
      contextType,
      relatedWorkoutId,
      relatedExerciseId,
      hasSuggestedActions,
      const DeepCollectionEquality().hash(_suggestedActions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String role,
      required final String content,
      @TimestampConverter() required final DateTime timestamp,
      final String contextType,
      final String? relatedWorkoutId,
      final String? relatedExerciseId,
      final bool hasSuggestedActions,
      final List<SuggestedAction> suggestedActions}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Message sender: 'user' or 'coach'
  String get role;
  @override

  /// Message content
  String get content;
  @override

  /// When the message was sent
  @TimestampConverter()
  DateTime get timestamp;
  @override

  /// Context type: 'general', 'workout_check_in', 'exercise_help', 'motivation', 'swap_request'
  String get contextType;
  @override

  /// Related workout ID (if discussing specific workout)
  String? get relatedWorkoutId;
  @override

  /// Related exercise ID (if discussing specific exercise)
  String? get relatedExerciseId;
  @override

  /// Whether this message contains suggested actions
  bool get hasSuggestedActions;
  @override

  /// Suggested action buttons (JSON encoded)
  List<SuggestedAction> get suggestedActions;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedAction _$SuggestedActionFromJson(Map<String, dynamic> json) {
  return _SuggestedAction.fromJson(json);
}

/// @nodoc
mixin _$SuggestedAction {
  /// Button label
  String get label => throw _privateConstructorUsedError;

  /// Action type: 'navigate', 'send_message', 'swap_exercise', 'start_workout'
  String get actionType => throw _privateConstructorUsedError;

  /// Action payload (route path, message text, or exercise ID)
  String get payload => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestedActionCopyWith<SuggestedAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedActionCopyWith<$Res> {
  factory $SuggestedActionCopyWith(
          SuggestedAction value, $Res Function(SuggestedAction) then) =
      _$SuggestedActionCopyWithImpl<$Res, SuggestedAction>;
  @useResult
  $Res call({String label, String actionType, String payload});
}

/// @nodoc
class _$SuggestedActionCopyWithImpl<$Res, $Val extends SuggestedAction>
    implements $SuggestedActionCopyWith<$Res> {
  _$SuggestedActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? actionType = null,
    Object? payload = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedActionImplCopyWith<$Res>
    implements $SuggestedActionCopyWith<$Res> {
  factory _$$SuggestedActionImplCopyWith(_$SuggestedActionImpl value,
          $Res Function(_$SuggestedActionImpl) then) =
      __$$SuggestedActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String actionType, String payload});
}

/// @nodoc
class __$$SuggestedActionImplCopyWithImpl<$Res>
    extends _$SuggestedActionCopyWithImpl<$Res, _$SuggestedActionImpl>
    implements _$$SuggestedActionImplCopyWith<$Res> {
  __$$SuggestedActionImplCopyWithImpl(
      _$SuggestedActionImpl _value, $Res Function(_$SuggestedActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? actionType = null,
    Object? payload = null,
  }) {
    return _then(_$SuggestedActionImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: null == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedActionImpl implements _SuggestedAction {
  const _$SuggestedActionImpl(
      {required this.label, required this.actionType, required this.payload});

  factory _$SuggestedActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedActionImplFromJson(json);

  /// Button label
  @override
  final String label;

  /// Action type: 'navigate', 'send_message', 'swap_exercise', 'start_workout'
  @override
  final String actionType;

  /// Action payload (route path, message text, or exercise ID)
  @override
  final String payload;

  @override
  String toString() {
    return 'SuggestedAction(label: $label, actionType: $actionType, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedActionImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.payload, payload) || other.payload == payload));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, actionType, payload);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedActionImplCopyWith<_$SuggestedActionImpl> get copyWith =>
      __$$SuggestedActionImplCopyWithImpl<_$SuggestedActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedActionImplToJson(
      this,
    );
  }
}

abstract class _SuggestedAction implements SuggestedAction {
  const factory _SuggestedAction(
      {required final String label,
      required final String actionType,
      required final String payload}) = _$SuggestedActionImpl;

  factory _SuggestedAction.fromJson(Map<String, dynamic> json) =
      _$SuggestedActionImpl.fromJson;

  @override

  /// Button label
  String get label;
  @override

  /// Action type: 'navigate', 'send_message', 'swap_exercise', 'start_workout'
  String get actionType;
  @override

  /// Action payload (route path, message text, or exercise ID)
  String get payload;
  @override
  @JsonKey(ignore: true)
  _$$SuggestedActionImplCopyWith<_$SuggestedActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
