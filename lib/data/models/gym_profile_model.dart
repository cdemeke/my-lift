import 'package:freezed_annotation/freezed_annotation.dart';

part 'gym_profile_model.freezed.dart';
part 'gym_profile_model.g.dart';

/// Represents a gym/workout location with its available equipment.
/// Stored in Firestore at: /users/{userId}/gymProfiles/{profileId}
@freezed
class GymProfile with _$GymProfile {
  const factory GymProfile({
    /// Unique identifier
    required String id,

    /// Profile name (e.g., "Home Gym", "Planet Fitness", "Travel")
    required String name,

    /// Profile type: 'home', 'commercial', 'travel', 'outdoor', 'bodyweight'
    required String type,

    /// List of available equipment IDs
    @Default([]) List<String> equipmentIds,

    /// Custom notes about this location
    String? notes,

    /// Icon identifier for UI display
    @Default('gym') String icon,

    /// Whether this is the default profile
    @Default(false) bool isDefault,
  }) = _GymProfile;

  /// Create a new gym profile
  factory GymProfile.create({
    required String id,
    required String name,
    required String type,
    List<String> equipmentIds = const [],
    bool isDefault = false,
  }) {
    return GymProfile(
      id: id,
      name: name,
      type: type,
      equipmentIds: equipmentIds,
      isDefault: isDefault,
      icon: _getIconForType(type),
    );
  }

  factory GymProfile.fromJson(Map<String, dynamic> json) =>
      _$GymProfileFromJson(json);
}

String _getIconForType(String type) {
  switch (type) {
    case GymProfileType.home:
      return 'home';
    case GymProfileType.commercial:
      return 'fitness_center';
    case GymProfileType.travel:
      return 'luggage';
    case GymProfileType.outdoor:
      return 'park';
    case GymProfileType.bodyweight:
      return 'accessibility_new';
    default:
      return 'fitness_center';
  }
}

/// Gym profile type options
class GymProfileType {
  static const String home = 'home';
  static const String commercial = 'commercial';
  static const String travel = 'travel';
  static const String outdoor = 'outdoor';
  static const String bodyweight = 'bodyweight';

  static const List<String> all = [
    home,
    commercial,
    travel,
    outdoor,
    bodyweight,
  ];

  static String getDisplayName(String type) {
    switch (type) {
      case home:
        return 'Home Gym';
      case commercial:
        return 'Commercial Gym';
      case travel:
        return 'Travel';
      case outdoor:
        return 'Outdoor';
      case bodyweight:
        return 'Bodyweight Only';
      default:
        return type;
    }
  }

  static String getDescription(String type) {
    switch (type) {
      case home:
        return 'Your personal home setup';
      case commercial:
        return 'Full gym with all equipment';
      case travel:
        return 'Hotel gym or limited equipment';
      case outdoor:
        return 'Park, track, or outdoor space';
      case bodyweight:
        return 'No equipment needed';
      default:
        return '';
    }
  }
}
