import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class GoalSpeedStep extends StatelessWidget {
  const GoalSpeedStep({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            "How fast do you want to reach your goal?",
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            'Slower is often more sustainable and healthier.',
            style: Theme.of(context).textTheme.bodyLarge,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 40),
          _buildSpeedOption(
            context,
            0.25,
            'Gradual',
            '0.25 kg/week',
            'Most sustainable',
            Icons.spa,
            profile.goalSpeedKgPerWeek == 0.25,
            () => userProvider.updateGoalSpeed(0.25),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          _buildSpeedOption(
            context,
            0.5,
            'Moderate',
            '0.5 kg/week',
            'Recommended',
            Icons.directions_walk,
            profile.goalSpeedKgPerWeek == 0.5,
            () => userProvider.updateGoalSpeed(0.5),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          _buildSpeedOption(
            context,
            0.75,
            'Fast',
            '0.75 kg/week',
            'Challenging',
            Icons.directions_run,
            profile.goalSpeedKgPerWeek == 0.75,
            () => userProvider.updateGoalSpeed(0.75),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          _buildSpeedOption(
            context,
            1.0,
            'Aggressive',
            '1.0 kg/week',
            'Maximum intensity',
            Icons.bolt,
            profile.goalSpeedKgPerWeek == 1.0,
            () => userProvider.updateGoalSpeed(1.0),
          ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildSpeedOption(
    BuildContext context,
    double speed,
    String title,
    String subtitle,
    String tag,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white24
                    : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white24
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.white54,
                      fontSize: 14,
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
    );
  }
}
