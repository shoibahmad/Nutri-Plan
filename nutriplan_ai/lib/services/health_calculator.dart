import '../models/user_profile.dart';
import '../models/health_metrics.dart';

class HealthCalculator {
  /// Calculate BMI (Body Mass Index)
  /// Formula: weight (kg) / height (m)²
  static double calculateBMI(double weightKg, double heightCm) {
    double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Get BMI category based on WHO standards
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  /// Calculate BMR using Mifflin-St Jeor Equation
  /// Male: (10 × weight) + (6.25 × height) - (5 × age) + 5
  /// Female: (10 × weight) + (6.25 × height) - (5 × age) - 161
  static double calculateBMR(
      double weightKg, double heightCm, int age, Gender gender) {
    double baseBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == Gender.male ? baseBMR + 5 : baseBMR - 161;
  }

  /// Get activity multiplier for TDEE calculation
  static double getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.2; // Little or no exercise
      case ActivityLevel.light:
        return 1.375; // Light exercise 1-3 days/week
      case ActivityLevel.moderate:
        return 1.55; // Moderate exercise 3-5 days/week
      case ActivityLevel.active:
        return 1.725; // Hard exercise 6-7 days/week
      case ActivityLevel.veryActive:
        return 1.9; // Very hard exercise, physical job
    }
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  static double calculateTDEE(double bmr, ActivityLevel activityLevel) {
    return bmr * getActivityMultiplier(activityLevel);
  }

  /// Calculate daily calorie target based on goal
  static double calculateDailyCalorieTarget(
      double tdee, GoalType goalType, double goalSpeedKgPerWeek) {
    // 1 kg of fat = ~7700 calories
    // To lose/gain 0.5kg per week, need deficit/surplus of ~550 cal/day
    double calorieAdjustment = goalSpeedKgPerWeek * 1100;

    switch (goalType) {
      case GoalType.lose:
        return tdee - calorieAdjustment;
      case GoalType.gain:
        return tdee + calorieAdjustment;
      case GoalType.maintain:
        return tdee;
    }
  }

  /// Calculate daily protein target (grams)
  static double calculateProteinTarget(
      double weightKg, GoalType goalType, ActivityLevel activityLevel) {
    double proteinPerKg;

    switch (goalType) {
      case GoalType.gain:
        // Higher protein for muscle gain
        proteinPerKg = activityLevel.index >= 3 ? 2.2 : 1.8;
        break;
      case GoalType.lose:
        // Higher protein to preserve muscle while cutting
        proteinPerKg = 1.6;
        break;
      case GoalType.maintain:
        proteinPerKg = activityLevel.index >= 3 ? 1.4 : 1.0;
        break;
    }

    return weightKg * proteinPerKg;
  }

  /// Calculate macros (carbs and fats after protein)
  static Map<String, double> calculateMacros(
      double dailyCalories, double proteinGrams, GoalType goalType) {
    // Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g
    double proteinCalories = proteinGrams * 4;
    double remainingCalories = dailyCalories - proteinCalories;

    double fatPercentage;
    switch (goalType) {
      case GoalType.lose:
        fatPercentage = 0.30; // Higher fat for satiety
        break;
      case GoalType.gain:
        fatPercentage = 0.25; // More carbs for energy
        break;
      case GoalType.maintain:
        fatPercentage = 0.28;
        break;
    }

    double fatCalories = remainingCalories * fatPercentage;
    double carbCalories = remainingCalories - fatCalories;

    return {
      'fat': fatCalories / 9,
      'carbs': carbCalories / 4,
    };
  }

  /// Calculate weeks to reach goal
  static double calculateWeeksToGoal(
      double currentWeight, double targetWeight, double speedKgPerWeek) {
    double weightDifference = (currentWeight - targetWeight).abs();
    return weightDifference / speedKgPerWeek;
  }

  /// Calculate all health metrics for a user profile
  static HealthMetrics? calculateAllMetrics(UserProfile profile) {
    if (profile.weightKg == null ||
        profile.heightCm == null ||
        profile.age == null ||
        profile.gender == null) {
      return null;
    }

    double bmi = calculateBMI(profile.weightKg!, profile.heightCm!);
    String bmiCategory = getBMICategory(bmi);

    double bmr = calculateBMR(
      profile.weightKg!,
      profile.heightCm!,
      profile.age!,
      profile.gender!,
    );

    double tdee = calculateTDEE(
      bmr,
      profile.activityLevel ?? ActivityLevel.moderate,
    );

    double dailyCalorieTarget = calculateDailyCalorieTarget(
      tdee,
      profile.goalType ?? GoalType.maintain,
      profile.goalSpeedKgPerWeek ?? 0.5,
    );

    double dailyProteinTarget = calculateProteinTarget(
      profile.weightKg!,
      profile.goalType ?? GoalType.maintain,
      profile.activityLevel ?? ActivityLevel.moderate,
    );

    Map<String, double> macros = calculateMacros(
      dailyCalorieTarget,
      dailyProteinTarget,
      profile.goalType ?? GoalType.maintain,
    );

    double weeksToGoal = profile.targetWeightKg != null
        ? calculateWeeksToGoal(
            profile.weightKg!,
            profile.targetWeightKg!,
            profile.goalSpeedKgPerWeek ?? 0.5,
          )
        : 0;

    return HealthMetrics(
      bmi: bmi,
      bmiCategory: bmiCategory,
      bmr: bmr,
      tdee: tdee,
      dailyCalorieTarget: dailyCalorieTarget,
      dailyProteinTarget: dailyProteinTarget,
      dailyCarbsTarget: macros['carbs']!,
      dailyFatTarget: macros['fat']!,
      weeksToGoal: weeksToGoal,
    );
  }
}
