import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';

class MealPlanProvider extends ChangeNotifier {
  List<DailyMealPlan> _weeklyPlan = [];
  DateTime _currentWeekStart = DateTime.now();

  List<DailyMealPlan> get weeklyPlan => _weeklyPlan;
  DateTime get currentWeekStart => _currentWeekStart;

  MealPlanProvider() {
    _generateWeeklyPlan();
  }

  void _generateWeeklyPlan() {
    final now = DateTime.now();
    // Start from Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _currentWeekStart = DateTime(monday.year, monday.month, monday.day);

    final meals = MealService.getSampleMeals();
    final breakfastMeals = meals.where((m) => m.mealType == MealType.breakfast).toList();
    final lunchMeals = meals.where((m) => m.mealType == MealType.lunch).toList();
    final dinnerMeals = meals.where((m) => m.mealType == MealType.dinner).toList();
    final snackMeals = meals.where((m) => m.mealType == MealType.snack).toList();

    _weeklyPlan = List.generate(7, (index) {
      final date = _currentWeekStart.add(Duration(days: index));
      return DailyMealPlan(
        date: date,
        breakfast: breakfastMeals[index % breakfastMeals.length],
        lunch: lunchMeals[index % lunchMeals.length],
        dinner: dinnerMeals[index % dinnerMeals.length],
        snack: snackMeals[index % snackMeals.length],
      );
    });

    notifyListeners();
  }

  DailyMealPlan? getTodaysPlan() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    try {
      return _weeklyPlan.firstWhere(
        (plan) => DateTime(plan.date.year, plan.date.month, plan.date.day) == today,
      );
    } catch (e) {
      return _weeklyPlan.isNotEmpty ? _weeklyPlan.first : null;
    }
  }

  void markMealCompleted(DateTime date, MealType mealType) {
    final index = _weeklyPlan.indexWhere(
      (plan) =>
          plan.date.year == date.year &&
          plan.date.month == date.month &&
          plan.date.day == date.day,
    );

    if (index != -1) {
      final plan = _weeklyPlan[index];
      _weeklyPlan[index] = DailyMealPlan(
        date: plan.date,
        breakfast: plan.breakfast,
        lunch: plan.lunch,
        dinner: plan.dinner,
        snack: plan.snack,
        breakfastCompleted: mealType == MealType.breakfast ? true : plan.breakfastCompleted,
        lunchCompleted: mealType == MealType.lunch ? true : plan.lunchCompleted,
        dinnerCompleted: mealType == MealType.dinner ? true : plan.dinnerCompleted,
        snackCompleted: mealType == MealType.snack ? true : plan.snackCompleted,
      );
      notifyListeners();
    }
  }

  void regeneratePlan() {
    _generateWeeklyPlan();
  }

  double getTotalWeeklyCost() {
    double total = 0;
    for (var plan in _weeklyPlan) {
      if (plan.breakfast != null) total += plan.breakfast!.estimatedCost;
      if (plan.lunch != null) total += plan.lunch!.estimatedCost;
      if (plan.dinner != null) total += plan.dinner!.estimatedCost;
      if (plan.snack != null) total += plan.snack!.estimatedCost;
    }
    return total;
  }

  double getAverageMealCost() {
    return getTotalWeeklyCost() / 28; // 4 meals per day * 7 days
  }
}
