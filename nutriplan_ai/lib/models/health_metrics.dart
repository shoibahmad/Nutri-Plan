class HealthMetrics {
  final double bmi;
  final String bmiCategory;
  final double bmr;
  final double tdee;
  final double dailyCalorieTarget;
  final double dailyProteinTarget;
  final double dailyCarbsTarget;
  final double dailyFatTarget;
  final double weeksToGoal;

  HealthMetrics({
    required this.bmi,
    required this.bmiCategory,
    required this.bmr,
    required this.tdee,
    required this.dailyCalorieTarget,
    required this.dailyProteinTarget,
    required this.dailyCarbsTarget,
    required this.dailyFatTarget,
    required this.weeksToGoal,
  });
}
