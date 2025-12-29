import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'fitness_goals_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Represents the authenticated user's profile and settings.
/// Stored in Firestore at: /users/{userId}
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    /// Firebase Auth UID - serves as document ID
    required String uid,

    /// User's display name
    required String displayName,

    /// Email address
    required String email,

    /// Profile photo URL (nullable for email-only signups)
    String? photoUrl,

    /// User's fitness goals configuration
    required FitnessGoals fitnessGoals,

    /// ID of the currently active gym profile
    required String activeGymProfileId,

    /// Whether user has completed onboarding flow
    @Default(false) bool onboardingComplete,

    /// FCM token for push notifications
    String? fcmToken,

    /// Preferred weight unit: 'lbs' or 'kg'
    @Default('lbs') String weightUnit,

    /// Account creation timestamp
    @TimestampConverter() required DateTime createdAt,

    /// Last activity timestamp
    @TimestampConverter() required DateTime lastActiveAt,
  }) = _UserModel;

  /// Create a new user with default values
  factory UserModel.newUser({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      fitnessGoals: const FitnessGoals(),
      activeGymProfileId: '',
      onboardingComplete: false,
      createdAt: now,
      lastActiveAt: now,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Custom converter for Firestore Timestamp <-> DateTime
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}

/// Optional timestamp converter for nullable DateTime fields
class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}
