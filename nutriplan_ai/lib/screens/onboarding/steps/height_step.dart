import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../theme/app_theme.dart';

class HeightStep extends StatefulWidget {
  const HeightStep({super.key});

  @override
  State<HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends State<HeightStep> {
  bool _isMetric = true;
  late TextEditingController _cmController;
  late TextEditingController _ftController;
  late TextEditingController _inController;

  @override
  void initState() {
    super.initState();
    _cmController = TextEditingController();
    _ftController = TextEditingController();
    _inController = TextEditingController();
  }

  @override
  void dispose() {
    _cmController.dispose();
    _ftController.dispose();
    _inController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    
    // Initialize controllers with existing values
    if (profile.heightCm != null && _cmController.text.isEmpty) {
      _cmController.text = profile.heightCm!.toStringAsFixed(0);
      final totalInches = profile.heightCm! / 2.54;
      _ftController.text = (totalInches / 12).floor().toString();
      _inController.text = (totalInches % 12).toStringAsFixed(0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "What's your height?",
              style: Theme.of(context).textTheme.displayMedium,
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              'This helps calculate your ideal body metrics.',
              style: Theme.of(context).textTheme.bodyLarge,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms),
            const SizedBox(height: 30),
            // Unit toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildUnitButton('cm', _isMetric, () {
                      setState(() => _isMetric = true);
                    }),
                  ),
                  Expanded(
                    child: _buildUnitButton('ft/in', !_isMetric, () {
                      setState(() => _isMetric = false);
                    }),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 40),
            // Input fields
            if (_isMetric)
              _buildMetricInput(userProvider)
            else
              _buildImperialInput(userProvider),
            const SizedBox(height: 40),
            // Height visualization
            if (profile.heightCm != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.height, color: Colors.white, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        '${profile.heightCm!.toStringAsFixed(0)} cm',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatFeetInches(profile.heightCm!),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 300.ms),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricInput(UserProvider userProvider) {
    return TextField(
      controller: _cmController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        color: Colors.white,
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '170',
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        suffixText: 'cm',
        suffixStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 24,
        ),
        filled: true,
        fillColor: AppTheme.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          userProvider.updateHeight(double.parse(value));
        }
      },
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildImperialInput(UserProvider userProvider) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ftController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '5',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 36,
              ),
              suffixText: 'ft',
              suffixStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: AppTheme.darkCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => _updateHeightFromImperial(userProvider),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _inController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '10',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 36,
              ),
              suffixText: 'in',
              suffixStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: AppTheme.darkCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (_) => _updateHeightFromImperial(userProvider),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  void _updateHeightFromImperial(UserProvider userProvider) {
    final ft = int.tryParse(_ftController.text) ?? 0;
    final inches = int.tryParse(_inController.text) ?? 0;
    final totalInches = (ft * 12) + inches;
    final cm = totalInches * 2.54;
    if (cm > 0) {
      userProvider.updateHeight(cm);
    }
  }

  String _formatFeetInches(double cm) {
    final totalInches = cm / 2.54;
    final ft = (totalInches / 12).floor();
    final inches = (totalInches % 12).round();
    return "${ft}' ${inches}\"";
  }
}
