import 'package:freezed_annotation/freezed_annotation.dart';
import 'gym_profile_model.dart';

part 'equipment_model.freezed.dart';
part 'equipment_model.g.dart';

/// Represents a piece of gym equipment.
/// Stored in Firestore at: /equipment/{equipmentId} (read-only catalog)
@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    /// Unique identifier
    required String id,

    /// Equipment name
    required String name,

    /// Category: 'free_weights', 'machines', 'cables', 'cardio', 'bodyweight', 'other'
    required String category,

    /// Icon asset path or identifier
    String? iconUrl,

    /// Whether commonly found in home gyms
    @Default(false) bool commonInHomeGym,

    /// Whether commonly found in commercial gyms
    @Default(true) bool commonInCommercialGym,

    /// Sort order for display
    @Default(0) int sortOrder,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}

/// Equipment category options
class EquipmentCategory {
  static const String freeWeights = 'free_weights';
  static const String machines = 'machines';
  static const String cables = 'cables';
  static const String cardio = 'cardio';
  static const String bodyweight = 'bodyweight';
  static const String other = 'other';

  static const List<String> all = [
    freeWeights,
    machines,
    cables,
    cardio,
    bodyweight,
    other,
  ];

  static String getDisplayName(String category) {
    switch (category) {
      case freeWeights:
        return 'Free Weights';
      case machines:
        return 'Machines';
      case cables:
        return 'Cables';
      case cardio:
        return 'Cardio';
      case bodyweight:
        return 'Bodyweight';
      case other:
        return 'Other';
      default:
        return category;
    }
  }
}

/// Default equipment catalog
class DefaultEquipment {
  static const List<Equipment> all = [
    // Free weights
    Equipment(
      id: 'barbell',
      name: 'Barbell',
      category: EquipmentCategory.freeWeights,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 1,
    ),
    Equipment(
      id: 'dumbbells',
      name: 'Dumbbells',
      category: EquipmentCategory.freeWeights,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 2,
    ),
    Equipment(
      id: 'kettlebells',
      name: 'Kettlebells',
      category: EquipmentCategory.freeWeights,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 3,
    ),
    Equipment(
      id: 'ez_bar',
      name: 'EZ Curl Bar',
      category: EquipmentCategory.freeWeights,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 4,
    ),
    Equipment(
      id: 'weight_plates',
      name: 'Weight Plates',
      category: EquipmentCategory.freeWeights,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 5,
    ),

    // Machines
    Equipment(
      id: 'squat_rack',
      name: 'Squat Rack / Power Rack',
      category: EquipmentCategory.machines,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 10,
    ),
    Equipment(
      id: 'bench_press',
      name: 'Bench Press Station',
      category: EquipmentCategory.machines,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 11,
    ),
    Equipment(
      id: 'adjustable_bench',
      name: 'Adjustable Bench',
      category: EquipmentCategory.machines,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 12,
    ),
    Equipment(
      id: 'leg_press',
      name: 'Leg Press Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 13,
    ),
    Equipment(
      id: 'smith_machine',
      name: 'Smith Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 14,
    ),
    Equipment(
      id: 'lat_pulldown',
      name: 'Lat Pulldown Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 15,
    ),
    Equipment(
      id: 'chest_press',
      name: 'Chest Press Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 16,
    ),
    Equipment(
      id: 'leg_curl',
      name: 'Leg Curl Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 17,
    ),
    Equipment(
      id: 'leg_extension',
      name: 'Leg Extension Machine',
      category: EquipmentCategory.machines,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 18,
    ),

    // Cables
    Equipment(
      id: 'cable_machine',
      name: 'Cable Machine / Functional Trainer',
      category: EquipmentCategory.cables,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 20,
    ),
    Equipment(
      id: 'cable_crossover',
      name: 'Cable Crossover',
      category: EquipmentCategory.cables,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 21,
    ),

    // Cardio
    Equipment(
      id: 'treadmill',
      name: 'Treadmill',
      category: EquipmentCategory.cardio,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 30,
    ),
    Equipment(
      id: 'stationary_bike',
      name: 'Stationary Bike',
      category: EquipmentCategory.cardio,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 31,
    ),
    Equipment(
      id: 'rowing_machine',
      name: 'Rowing Machine',
      category: EquipmentCategory.cardio,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 32,
    ),
    Equipment(
      id: 'elliptical',
      name: 'Elliptical',
      category: EquipmentCategory.cardio,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 33,
    ),
    Equipment(
      id: 'stair_climber',
      name: 'Stair Climber',
      category: EquipmentCategory.cardio,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 34,
    ),

    // Bodyweight
    Equipment(
      id: 'pull_up_bar',
      name: 'Pull-Up Bar',
      category: EquipmentCategory.bodyweight,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 40,
    ),
    Equipment(
      id: 'dip_station',
      name: 'Dip Station / Parallel Bars',
      category: EquipmentCategory.bodyweight,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 41,
    ),
    Equipment(
      id: 'resistance_bands',
      name: 'Resistance Bands',
      category: EquipmentCategory.bodyweight,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 42,
    ),
    Equipment(
      id: 'exercise_mat',
      name: 'Exercise Mat',
      category: EquipmentCategory.bodyweight,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 43,
    ),
    Equipment(
      id: 'foam_roller',
      name: 'Foam Roller',
      category: EquipmentCategory.bodyweight,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 44,
    ),

    // Other
    Equipment(
      id: 'medicine_ball',
      name: 'Medicine Ball',
      category: EquipmentCategory.other,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 50,
    ),
    Equipment(
      id: 'battle_ropes',
      name: 'Battle Ropes',
      category: EquipmentCategory.other,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 51,
    ),
    Equipment(
      id: 'trx',
      name: 'TRX / Suspension Trainer',
      category: EquipmentCategory.other,
      commonInHomeGym: true,
      commonInCommercialGym: true,
      sortOrder: 52,
    ),
    Equipment(
      id: 'bosu_ball',
      name: 'BOSU Ball',
      category: EquipmentCategory.other,
      commonInHomeGym: false,
      commonInCommercialGym: true,
      sortOrder: 53,
    ),
  ];

  /// Get equipment for a specific profile type
  static List<Equipment> getDefaultForProfileType(String profileType) {
    switch (profileType) {
      case GymProfileType.commercial:
        return all;
      case GymProfileType.home:
        return all.where((e) => e.commonInHomeGym).toList();
      case GymProfileType.bodyweight:
        return all
            .where((e) => e.category == EquipmentCategory.bodyweight)
            .toList();
      case GymProfileType.travel:
        return all
            .where((e) =>
                e.category == EquipmentCategory.bodyweight ||
                e.id == 'resistance_bands')
            .toList();
      default:
        return [];
    }
  }
}

