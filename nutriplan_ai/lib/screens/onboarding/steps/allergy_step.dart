import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/selection_chip.dart';

class AllergyStep extends StatelessWidget {
  const AllergyStep({super.key});

  static const allergies = [
    {'name': 'Peanuts', 'emoji': '🥜'},
    {'name': 'Tree Nuts', 'emoji': '🌰'},
    {'name': 'Milk', 'emoji': '🥛'},
    {'name': 'Eggs', 'emoji': '🥚'},
    {'name': 'Fish', 'emoji': '🐟'},
    {'name': 'Shellfish', 'emoji': '🦐'},
    {'name': 'Wheat', 'emoji': '🌾'},
    {'name': 'Soy', 'emoji': '🫘'},
    {'name': 'Sesame', 'emoji': '🌿'},
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
            "Any food allergies?",
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          Text(
            "We'll make sure to exclude these from your meal plans.",
            style: Theme.of(context).textTheme.bodyLarge,
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: AppTheme.warning, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Skip this step if you have no allergies',
                    style: TextStyle(color: AppTheme.warning, fontSize: 13),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allergies.asMap().entries.map((entry) {
                  final index = entry.key;
                  final allergy = entry.value;
                  final isSelected = profile.allergies.contains(allergy['name']);

                  return SelectionChip(
                    label: allergy['name']!,
                    emoji: allergy['emoji'],
                    isSelected: isSelected,
                    onTap: () => userProvider.toggleAllergy(allergy['name']!),
                  ).animate().fadeIn(delay: (200 + index * 50).ms).scale(begin: const Offset(0.9, 0.9));
                }).toList(),
              ),
            ),
          ),
          if (profile.allergies.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.do_not_disturb_alt, color: AppTheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${profile.allergies.length} allerg${profile.allergies.length == 1 ? 'y' : 'ies'} selected',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => userProvider.updateAllergies([]),
                    child: const Text('Clear all'),
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
