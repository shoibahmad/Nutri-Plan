import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/selection_chip.dart';

class LifestyleStep extends StatelessWidget {
  const LifestyleStep({super.key});

  static const cookingTimes = [
    {'value': 15, 'label': '< 15 min', 'emoji': '⚡'},
    {'value': 30, 'label': '15-30 min', 'emoji': '⏱️'},
    {'value': 45, 'label': '30-45 min', 'emoji': '🕐'},
    {'value': 60, 'label': '45-60 min', 'emoji': '👨‍🍳'},
    {'value': 90, 'label': '60+ min', 'emoji': '🎯'},
  ];

  static const equipment = [
    {'name': 'Stovetop', 'emoji': '🔥'},
    {'name': 'Oven', 'emoji': '🍳'},
    {'name': 'Microwave', 'emoji': '📡'},
    {'name': 'Air Fryer', 'emoji': '🌪️'},
    {'name': 'Instant Pot', 'emoji': '🥘'},
    {'name': 'Rice Cooker', 'emoji': '🍚'},
    {'name': 'Blender', 'emoji': '🥤'},
    {'name': 'Grill', 'emoji': '🍖'},
  ];

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
              "Your cooking lifestyle",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              "We'll suggest meals that fit your routine.",
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 30),
            // Cooking Time
            Text(
              'How much time can you cook?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cookingTimes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final time = entry.value;
                  final isSelected = profile.cookingTimeMinutes == time['value'];

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => userProvider.updateCookingTime(time['value'] as int),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppTheme.primaryGradient : null,
                          color: isSelected ? null : AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(time['emoji'] as String, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text(
                              time['label'] as String,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (200 + index * 50).ms),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            // Kitchen Equipment
            Text(
              'What equipment do you have?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: equipment.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = profile.kitchenEquipment.contains(item['name']);

                return SelectionChip(
                  label: item['name']!,
                  emoji: item['emoji'],
                  isSelected: isSelected,
                  onTap: () => userProvider.toggleEquipment(item['name']!),
                ).animate().fadeIn(delay: (350 + index * 40).ms);
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Cooking Frequency
            Text(
              'How often do you cook per week?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${profile.cookingFrequencyPerWeek ?? 5} meals/week',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getFrequencyLabel(profile.cookingFrequencyPerWeek ?? 5),
                          style: const TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppTheme.primaryGreen,
                      inactiveTrackColor: Colors.white12,
                      thumbColor: Colors.white,
                      overlayColor: AppTheme.primaryGreen.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: (profile.cookingFrequencyPerWeek ?? 5).toDouble(),
                      min: 1,
                      max: 21,
                      divisions: 20,
                      onChanged: (value) => userProvider.updateCookingFrequency(value.round()),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 550.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getFrequencyLabel(int frequency) {
    if (frequency <= 3) return 'Occasional';
    if (frequency <= 7) return 'Regular';
    if (frequency <= 14) return 'Frequent';
    return 'Daily chef';
  }
}
