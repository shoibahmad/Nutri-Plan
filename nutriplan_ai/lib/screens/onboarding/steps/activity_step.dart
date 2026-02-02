import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../models/user_profile.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class ActivityStep extends StatelessWidget {
  const ActivityStep({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "How active are you?",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              'This helps us calculate your daily calorie needs.',
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 30),
            ..._buildActivityOptions(context, userProvider, profile),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivityOptions(
    BuildContext context,
    UserProvider userProvider,
    UserProfile profile,
  ) {
    final activities = [
      {
        'level': ActivityLevel.sedentary,
        'emoji': '🪑',
        'title': 'Sedentary',
        'description': 'Little or no exercise, desk job',
      },
      {
        'level': ActivityLevel.light,
        'emoji': '🚶',
        'title': 'Lightly Active',
        'description': 'Light exercise 1-3 days/week',
      },
      {
        'level': ActivityLevel.moderate,
        'emoji': '🏃',
        'title': 'Moderately Active',
        'description': 'Moderate exercise 3-5 days/week',
      },
      {
        'level': ActivityLevel.active,
        'emoji': '🏋️',
        'title': 'Very Active',
        'description': 'Hard exercise 6-7 days/week',
      },
      {
        'level': ActivityLevel.veryActive,
        'emoji': '🏆',
        'title': 'Extremely Active',
        'description': 'Very hard exercise, physical job',
      },
    ];

    return activities.asMap().entries.map((entry) {
      final index = entry.key;
      final activity = entry.value;
      final level = activity['level'] as ActivityLevel;
      final isSelected = profile.activityLevel == level;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => userProvider.updateActivityLevel(level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isSelected ? AppTheme.primaryGradient : null,
              color: isSelected ? null : AppTheme.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.white12,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  activity['emoji'] as String,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity['description'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24,
                  ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (200 + index * 100).ms).slideX(begin: 0.1, end: 0),
      );
    }).toList();
  }
}
