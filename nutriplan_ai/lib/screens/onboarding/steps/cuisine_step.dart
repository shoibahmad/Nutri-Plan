import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/selection_chip.dart';

class CuisineStep extends StatelessWidget {
  const CuisineStep({super.key});

  static const cuisines = [
    {'name': 'Indian', 'emoji': '🇮🇳'},
    {'name': 'Chinese', 'emoji': '🇨🇳'},
    {'name': 'Italian', 'emoji': '🇮🇹'},
    {'name': 'Mexican', 'emoji': '🇲🇽'},
    {'name': 'Japanese', 'emoji': '🇯🇵'},
    {'name': 'Thai', 'emoji': '🇹🇭'},
    {'name': 'American', 'emoji': '🇺🇸'},
    {'name': 'Mediterranean', 'emoji': '🫒'},
    {'name': 'Korean', 'emoji': '🇰🇷'},
    {'name': 'Vietnamese', 'emoji': '🇻🇳'},
    {'name': 'French', 'emoji': '🇫🇷'},
    {'name': 'Middle Eastern', 'emoji': '🧆'},
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
            "What cuisines do you enjoy?",
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            "Select all that you'd like in your meal plans.",
            style: Theme.of(context).textTheme.bodyLarge,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: cuisines.asMap().entries.map((entry) {
                  final index = entry.key;
                  final cuisine = entry.value;
                  final isSelected = profile.cuisinePreferences.contains(cuisine['name']);

                  return SelectionChip(
                    label: cuisine['name']!,
                    emoji: cuisine['emoji'],
                    isSelected: isSelected,
                    onTap: () => userProvider.toggleCuisine(cuisine['name']!),
                  ).animate().fadeIn(delay: (150 + index * 40).ms).scale(begin: const Offset(0.9, 0.9));
                }).toList(),
              ),
            ),
          ),
          if (profile.cuisinePreferences.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.primaryBlue.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.restaurant, color: AppTheme.primaryGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${profile.cuisinePreferences.length} cuisine${profile.cuisinePreferences.length == 1 ? '' : 's'} selected',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ],
        ],
      ),
    );
  }
}
