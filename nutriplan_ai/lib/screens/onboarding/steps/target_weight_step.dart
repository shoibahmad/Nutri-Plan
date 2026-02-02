import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../models/user_profile.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class TargetWeightStep extends StatefulWidget {
  const TargetWeightStep({super.key});

  @override
  State<TargetWeightStep> createState() => _TargetWeightStepState();
}

class _TargetWeightStepState extends State<TargetWeightStep> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    
    if (profile.targetWeightKg != null && _controller.text.isEmpty) {
      _controller.text = profile.targetWeightKg!.toStringAsFixed(1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "What's your goal weight?",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              "We'll create a personalized plan to help you reach this goal.",
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '65.0',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                ),
                suffixText: 'kg',
                suffixStyle: const TextStyle(
                  color: Colors.white54,
                  fontSize: 28,
                ),
                filled: true,
                fillColor: AppTheme.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 30),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final weight = double.tryParse(value);
                  if (weight != null) {
                    userProvider.updateTargetWeight(weight);
                    _updateGoalType(userProvider, weight);
                  }
                }
              },
            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 30),
            if (profile.weightKg != null && profile.targetWeightKg != null)
              _buildGoalSummary(profile),
          ],
        ),
      ),
    );
  }

  void _updateGoalType(UserProvider userProvider, double targetWeight) {
    final currentWeight = userProvider.profile.weightKg;
    if (currentWeight != null) {
      if (targetWeight < currentWeight - 1) {
        userProvider.updateGoalType(GoalType.lose);
      } else if (targetWeight > currentWeight + 1) {
        userProvider.updateGoalType(GoalType.gain);
      } else {
        userProvider.updateGoalType(GoalType.maintain);
      }
    }
  }

  Widget _buildGoalSummary(UserProfile profile) {
    final difference = profile.targetWeightKg! - profile.weightKg!;
    final isLosing = difference < 0;
    final isMaintaining = difference.abs() < 1;
    
    String goalText;
    IconData icon;
    Color color;

    if (isMaintaining) {
      goalText = 'Maintain Weight';
      icon = Icons.balance;
      color = AppTheme.info;
    } else if (isLosing) {
      goalText = 'Lose ${difference.abs().toStringAsFixed(1)} kg';
      icon = Icons.trending_down;
      color = AppTheme.primaryGreen;
    } else {
      goalText = 'Gain ${difference.abs().toStringAsFixed(1)} kg';
      icon = Icons.trending_up;
      color = AppTheme.primaryPurple;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Goal',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  goalText,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${profile.weightKg!.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.arrow_forward, color: color, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${profile.targetWeightKg!.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
