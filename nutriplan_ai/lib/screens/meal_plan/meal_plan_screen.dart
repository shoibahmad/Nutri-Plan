import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/meal_plan_provider.dart';
import '../../models/meal.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // 0-indexed

  @override
  Widget build(BuildContext context) {
    final mealPlanProvider = context.watch<MealPlanProvider>();
    final weeklyPlan = mealPlanProvider.weeklyPlan;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Meal Plan',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Week of ${DateFormat('MMM d').format(mealPlanProvider.currentWeekStart)}',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => mealPlanProvider.regeneratePlan(),
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            
            // Day Selector
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = mealPlanProvider.currentWeekStart.add(Duration(days: index));
                  final isSelected = index == _selectedDay;
                  final isToday = _isToday(date);
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppTheme.primaryGradient : null,
                        color: isSelected ? null : AppTheme.darkCard,
                        borderRadius: BorderRadius.circular(16),
                        border: isToday && !isSelected
                            ? Border.all(color: AppTheme.primaryGreen, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(date).substring(0, 2),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white,
                              fontSize: 20,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (100 + index * 50).ms);
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Selected Day Meals
            Expanded(
              child: weeklyPlan.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: AppTheme.primaryGreen),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMealSection(
                            context,
                            'Breakfast',
                            '🌅',
                            weeklyPlan[_selectedDay].breakfast,
                            weeklyPlan[_selectedDay].breakfastCompleted,
                            () => mealPlanProvider.markMealCompleted(
                              weeklyPlan[_selectedDay].date,
                              MealType.breakfast,
                            ),
                          ),
                          _buildMealSection(
                            context,
                            'Lunch',
                            '☀️',
                            weeklyPlan[_selectedDay].lunch,
                            weeklyPlan[_selectedDay].lunchCompleted,
                            () => mealPlanProvider.markMealCompleted(
                              weeklyPlan[_selectedDay].date,
                              MealType.lunch,
                            ),
                          ),
                          _buildMealSection(
                            context,
                            'Dinner',
                            '🌙',
                            weeklyPlan[_selectedDay].dinner,
                            weeklyPlan[_selectedDay].dinnerCompleted,
                            () => mealPlanProvider.markMealCompleted(
                              weeklyPlan[_selectedDay].date,
                              MealType.dinner,
                            ),
                          ),
                          _buildMealSection(
                            context,
                            'Snack',
                            '🍎',
                            weeklyPlan[_selectedDay].snack,
                            weeklyPlan[_selectedDay].snackCompleted,
                            () => mealPlanProvider.markMealCompleted(
                              weeklyPlan[_selectedDay].date,
                              MealType.snack,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Day Summary
                          GlassmorphicCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Day Summary',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildSummaryRow(
                                  'Total Calories',
                                  '${weeklyPlan[_selectedDay].totalCalories} kcal',
                                  Icons.local_fire_department,
                                ),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Total Protein',
                                  '${weeklyPlan[_selectedDay].totalProtein.toStringAsFixed(1)}g',
                                  Icons.fitness_center,
                                ),
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Meals Completed',
                                  '${weeklyPlan[_selectedDay].completedMeals} / 4',
                                  Icons.check_circle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    String title,
    String emoji,
    Meal? meal,
    bool isCompleted,
    VoidCallback onMarkComplete,
  ) {
    if (meal == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onMarkComplete,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.success.withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _getMealIcon(meal.mealType),
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTag('${meal.calories} kcal', AppTheme.primaryOrange),
                            const SizedBox(width: 8),
                            _buildTag('${meal.protein.toInt()}g protein', AppTheme.primaryPurple),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.success
                          : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  IconData _getMealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie;
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
