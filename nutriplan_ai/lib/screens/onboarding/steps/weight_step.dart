import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class WeightStep extends StatefulWidget {
  const WeightStep({super.key});

  @override
  State<WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends State<WeightStep> {
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
    
    if (profile.weightKg != null && _controller.text.isEmpty) {
      _controller.text = profile.weightKg!.toStringAsFixed(1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "What's your current weight?",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              "Don't worry, this is private and used only for calculations.",
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
                hintText: '70.0',
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
                    userProvider.updateWeight(weight);
                  }
                }
              },
            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),
            const SizedBox(height: 20),
            if (profile.weightKg != null)
              Center(
                child: Text(
                  '≈ ${(profile.weightKg! * 2.205).toStringAsFixed(1)} lbs',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 40),
            if (profile.heightCm != null && profile.weightKg != null) ...[
              _buildBMIPreview(profile.weightKg!, profile.heightCm!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBMIPreview(double weight, double height) {
    final heightM = height / 100;
    final bmi = weight / (heightM * heightM);
    String category;
    Color color;

    if (bmi < 18.5) {
      category = 'Underweight';
      color = Colors.yellow;
    } else if (bmi < 25) {
      category = 'Normal';
      color = AppTheme.success;
    } else if (bmi < 30) {
      category = 'Overweight';
      color = Colors.orange;
    } else {
      category = 'Obese';
      color = AppTheme.error;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                bmi.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current BMI',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
