import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/selection_chip.dart';

class HealthFocusStep extends StatelessWidget {
  const HealthFocusStep({super.key});

  static const healthGoals = [
    {'name': 'Muscle Gain', 'emoji': '💪', 'desc': 'High protein meals'},
    {'name': 'Energy Boost', 'emoji': '⚡', 'desc': 'Complex carbs & nutrients'},
    {'name': 'Better Sleep', 'emoji': '😴', 'desc': 'Sleep-promoting foods'},
    {'name': 'Skin Health', 'emoji': '✨', 'desc': 'Antioxidant-rich foods'},
    {'name': 'Gut Health', 'emoji': '🦠', 'desc': 'Probiotic & fiber-rich'},
    {'name': 'Heart Health', 'emoji': '❤️', 'desc': 'Low sodium, healthy fats'},
    {'name': 'Brain Health', 'emoji': '🧠', 'desc': 'Omega-3 & vitamins'},
    {'name': 'Immunity', 'emoji': '🛡️', 'desc': 'Vitamin C & zinc rich'},
  ];

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
            "Any health focus areas?",
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            "We'll prioritize foods that support these goals.",
            style: Theme.of(context).textTheme.bodyLarge,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: healthGoals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final goal = entry.value;
                  final isSelected = profile.healthFocus.contains(goal['name']);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => userProvider.toggleHealthFocus(goal['name']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppTheme.accentGradient : null,
                          color: isSelected ? null : AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : Colors.white12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(goal['emoji']!, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal['name']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    goal['desc']!,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white70 : Colors.white54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.white),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (150 + index * 60).ms).slideY(begin: 0.1, end: 0),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
