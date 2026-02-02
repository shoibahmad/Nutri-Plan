class Meal {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String cuisine;
  final MealType mealType;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int preparationTime;
  final int cookingTime;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> dietaryTags;
  final double estimatedCost;
  final int servings;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cuisine,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.preparationTime,
    required this.cookingTime,
    required this.ingredients,
    required this.instructions,
    required this.dietaryTags,
    required this.estimatedCost,
    required this.servings,
  });

  int get totalTime => preparationTime + cookingTime;
}

enum MealType { breakfast, lunch, dinner, snack }

class DailyMealPlan {
  final DateTime date;
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? dinner;
  final Meal? snack;
  final bool breakfastCompleted;
  final bool lunchCompleted;
  final bool dinnerCompleted;
  final bool snackCompleted;

  DailyMealPlan({
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snack,
    this.breakfastCompleted = false,
    this.lunchCompleted = false,
    this.dinnerCompleted = false,
    this.snackCompleted = false,
  });

  int get totalCalories {
    int total = 0;
    if (breakfast != null) total += breakfast!.calories;
    if (lunch != null) total += lunch!.calories;
    if (dinner != null) total += dinner!.calories;
    if (snack != null) total += snack!.calories;
    return total;
  }

  double get totalProtein {
    double total = 0;
    if (breakfast != null) total += breakfast!.protein;
    if (lunch != null) total += lunch!.protein;
    if (dinner != null) total += dinner!.protein;
    if (snack != null) total += snack!.protein;
    return total;
  }

  int get completedMeals {
    int count = 0;
    if (breakfastCompleted) count++;
    if (lunchCompleted) count++;
    if (dinnerCompleted) count++;
    if (snackCompleted) count++;
    return count;
  }

  double get completionPercentage => completedMeals / 4;
}
