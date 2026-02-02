enum Gender { male, female, other }

enum GoalType { lose, maintain, gain }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

enum DietType { standard, keto, vegan, vegetarian, paleo, mediterranean, glutenFree }

class UserProfile {
  Gender? gender;
  DateTime? dateOfBirth;
  double? heightCm;
  double? weightKg;
  double? targetWeightKg;
  GoalType? goalType;
  double? goalSpeedKgPerWeek; // 0.25, 0.5, 0.75, 1.0
  ActivityLevel? activityLevel;
  DietType? dietType;
  List<String> allergies;
  List<String> dislikes;
  List<String> cuisinePreferences;
  List<String> healthFocus;
  int? cookingTimeMinutes;
  List<String> kitchenEquipment;
  int? cookingFrequencyPerWeek;
  double? weeklyBudget;
  int dayStreak;
  DateTime? lastActiveDate;

  UserProfile({
    this.gender,
    this.dateOfBirth,
    this.heightCm,
    this.weightKg,
    this.targetWeightKg,
    this.goalType,
    this.goalSpeedKgPerWeek = 0.5,
    this.activityLevel = ActivityLevel.moderate,
    this.dietType = DietType.standard,
    List<String>? allergies,
    List<String>? dislikes,
    List<String>? cuisinePreferences,
    List<String>? healthFocus,
    this.cookingTimeMinutes,
    List<String>? kitchenEquipment,
    this.cookingFrequencyPerWeek,
    this.weeklyBudget,
    this.dayStreak = 0,
    this.lastActiveDate,
  })  : allergies = allergies ?? [],
        dislikes = dislikes ?? [],
        cuisinePreferences = cuisinePreferences ?? [],
        healthFocus = healthFocus ?? [],
        kitchenEquipment = kitchenEquipment ?? [];

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int years = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  Map<String, dynamic> toJson() => {
        'gender': gender?.name,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'goalType': goalType?.name,
        'goalSpeedKgPerWeek': goalSpeedKgPerWeek,
        'activityLevel': activityLevel?.name,
        'dietType': dietType?.name,
        'allergies': allergies,
        'dislikes': dislikes,
        'cuisinePreferences': cuisinePreferences,
        'healthFocus': healthFocus,
        'cookingTimeMinutes': cookingTimeMinutes,
        'kitchenEquipment': kitchenEquipment,
        'cookingFrequencyPerWeek': cookingFrequencyPerWeek,
        'weeklyBudget': weeklyBudget,
        'dayStreak': dayStreak,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'] != null
          ? Gender.values.firstWhere((e) => e.name == json['gender'])
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      heightCm: json['heightCm']?.toDouble(),
      weightKg: json['weightKg']?.toDouble(),
      targetWeightKg: json['targetWeightKg']?.toDouble(),
      goalType: json['goalType'] != null
          ? GoalType.values.firstWhere((e) => e.name == json['goalType'])
          : null,
      goalSpeedKgPerWeek: json['goalSpeedKgPerWeek']?.toDouble(),
      activityLevel: json['activityLevel'] != null
          ? ActivityLevel.values
              .firstWhere((e) => e.name == json['activityLevel'])
          : null,
      dietType: json['dietType'] != null
          ? DietType.values.firstWhere((e) => e.name == json['dietType'])
          : null,
      allergies: List<String>.from(json['allergies'] ?? []),
      dislikes: List<String>.from(json['dislikes'] ?? []),
      cuisinePreferences: List<String>.from(json['cuisinePreferences'] ?? []),
      healthFocus: List<String>.from(json['healthFocus'] ?? []),
      cookingTimeMinutes: json['cookingTimeMinutes'],
      kitchenEquipment: List<String>.from(json['kitchenEquipment'] ?? []),
      cookingFrequencyPerWeek: json['cookingFrequencyPerWeek'],
      weeklyBudget: json['weeklyBudget']?.toDouble(),
      dayStreak: json['dayStreak'] ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : null,
    );
  }
}
