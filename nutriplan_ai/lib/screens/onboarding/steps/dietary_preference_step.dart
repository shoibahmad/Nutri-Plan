import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../models/user_profile.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class DietaryPreferenceStep extends StatelessWidget {
  const DietaryPreferenceStep({super.key});

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
              "Any dietary preferences?",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              "We'll customize your meals accordingly.",
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 30),
            ..._buildDietOptions(context, userProvider, profile),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDietOptions(
    BuildContext context,
    UserProvider userProvider,
    UserProfile profile,
  ) {
    final diets = [
      {'type': DietType.standard, 'emoji': '🍽️', 'title': 'Standard', 'desc': 'No restrictions'},
      {'type': DietType.vegetarian, 'emoji': '🥬', 'title': 'Vegetarian', 'desc': 'No meat'},
      {'type': DietType.vegan, 'emoji': '🌱', 'title': 'Vegan', 'desc': 'No animal products'},
      {'type': DietType.keto, 'emoji': '🥑', 'title': 'Keto', 'desc': 'Low carb, high fat'},
      {'type': DietType.paleo, 'emoji': '🦴', 'title': 'Paleo', 'desc': 'Whole foods only'},
      {'type': DietType.mediterranean, 'emoji': '🫒', 'title': 'Mediterranean', 'desc': 'Heart-healthy'},
      {'type': DietType.glutenFree, 'emoji': '🌾', 'title': 'Gluten-Free', 'desc': 'No gluten'},
    ];

    return diets.asMap().entries.map((entry) {
      final index = entry.key;
      final diet = entry.value;
      final type = diet['type'] as DietType;
      final isSelected = profile.dietType == type;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => userProvider.updateDietType(type),
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
            ),
            child: Row(
              children: [
                Text(diet['emoji'] as String, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diet['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      Text(
                        diet['desc'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (150 + index * 80).ms).slideY(begin: 0.1, end: 0),
      );
    }).toList();
  }
}
