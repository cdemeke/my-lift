import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

/// Represents a message in the AI coach chat.
/// Stored in Firestore at: /users/{userId}/chatHistory/{messageId}
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    /// Unique identifier
    required String id,

    /// Message sender: 'user' or 'coach'
    required String role,

    /// Message content
    required String content,

    /// When the message was sent
    @TimestampConverter() required DateTime timestamp,

    /// Context type: 'general', 'workout_check_in', 'exercise_help', 'motivation', 'swap_request'
    @Default('general') String contextType,

    /// Related workout ID (if discussing specific workout)
    String? relatedWorkoutId,

    /// Related exercise ID (if discussing specific exercise)
    String? relatedExerciseId,

    /// Whether this message contains suggested actions
    @Default(false) bool hasSuggestedActions,

    /// Suggested action buttons (JSON encoded)
    @Default([]) List<SuggestedAction> suggestedActions,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  /// Create a user message
  factory ChatMessage.user({
    required String id,
    required String content,
    String contextType = 'general',
    String? relatedWorkoutId,
    String? relatedExerciseId,
  }) {
    return ChatMessage(
      id: id,
      role: ChatRole.user,
      content: content,
      timestamp: DateTime.now(),
      contextType: contextType,
      relatedWorkoutId: relatedWorkoutId,
      relatedExerciseId: relatedExerciseId,
    );
  }

  /// Create a coach message
  factory ChatMessage.coach({
    required String id,
    required String content,
    String contextType = 'general',
    String? relatedWorkoutId,
    String? relatedExerciseId,
    List<SuggestedAction> suggestedActions = const [],
  }) {
    return ChatMessage(
      id: id,
      role: ChatRole.coach,
      content: content,
      timestamp: DateTime.now(),
      contextType: contextType,
      relatedWorkoutId: relatedWorkoutId,
      relatedExerciseId: relatedExerciseId,
      hasSuggestedActions: suggestedActions.isNotEmpty,
      suggestedActions: suggestedActions,
    );
  }
}

/// Suggested action button in coach messages
@freezed
class SuggestedAction with _$SuggestedAction {
  const factory SuggestedAction({
    /// Button label
    required String label,

    /// Action type: 'navigate', 'send_message', 'swap_exercise', 'start_workout'
    required String actionType,

    /// Action payload (route path, message text, or exercise ID)
    required String payload,
  }) = _SuggestedAction;

  factory SuggestedAction.fromJson(Map<String, dynamic> json) =>
      _$SuggestedActionFromJson(json);
}

/// Chat role options
class ChatRole {
  static const String user = 'user';
  static const String coach = 'coach';
}

/// Chat context type options
class ChatContextType {
  static const String general = 'general';
  static const String workoutCheckIn = 'workout_check_in';
  static const String exerciseHelp = 'exercise_help';
  static const String motivation = 'motivation';
  static const String swapRequest = 'swap_request';
  static const String planGeneration = 'plan_generation';

  static const List<String> all = [
    general,
    workoutCheckIn,
    exerciseHelp,
    motivation,
    swapRequest,
    planGeneration,
  ];
}

/// Suggested action type options
class ActionType {
  static const String navigate = 'navigate';
  static const String sendMessage = 'send_message';
  static const String swapExercise = 'swap_exercise';
  static const String startWorkout = 'start_workout';
  static const String skipWorkout = 'skip_workout';
  static const String reschedule = 'reschedule';
}
