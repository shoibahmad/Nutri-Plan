import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/progress_ring.dart';
import '../onboarding/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;
    final metrics = userProvider.healthMetrics;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    IconButton(
                      onPressed: () => _showSettingsSheet(context),
                      icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.darkCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassmorphicCard(
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _getGenderEmoji(profile.gender),
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profile.age ?? '--'} years old',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.heightCm?.toStringAsFixed(0) ?? '--'} cm • ${profile.weightKg?.toStringAsFixed(1) ?? '--'} kg',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Health Metrics
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Health Metrics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 16),

              // Metrics Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'BMI',
                        metrics?.bmi.toStringAsFixed(1) ?? '--',
                        metrics?.bmiCategory ?? '',
                        _getBMIColor(metrics?.bmi ?? 0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'BMR',
                        '${metrics?.bmr.toInt() ?? '--'}',
                        'kcal/day',
                        AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'TDEE',
                        '${metrics?.tdee.toInt() ?? '--'}',
                        'kcal/day',
                        AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'Target',
                        '${metrics?.dailyCalorieTarget.toInt() ?? '--'}',
                        'kcal/day',
                        AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 24),

              // Goal Progress
              if (profile.targetWeightKg != null && profile.weightKg != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Goal Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildWeightLabel(
                                        'Current',
                                        profile.weightKg!,
                                      ),
                                      _buildWeightLabel(
                                        'Target',
                                        profile.targetWeightKg!,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: _calculateGoalProgress(
                                        profile.weightKg!,
                                        profile.targetWeightKg!,
                                      ),
                                      backgroundColor: Colors.white12,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryGreen,
                                      ),
                                      minHeight: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    '${metrics?.weeksToGoal.toStringAsFixed(0) ?? '--'} weeks to go',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 24),

              // Macros Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Macro Targets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              child: PieChart(
                                PieChartData(
                                  sectionsSpace: 4,
                                  centerSpaceRadius: 40,
                                  sections: [
                                    PieChartSectionData(
                                      value: metrics?.dailyProteinTarget ?? 1,
                                      title: '',
                                      color: AppTheme.primaryPurple,
                                      radius: 25,
                                    ),
                                    PieChartSectionData(
                                      value: metrics?.dailyCarbsTarget ?? 1,
                                      title: '',
                                      color: AppTheme.primaryBlue,
                                      radius: 25,
                                    ),
                                    PieChartSectionData(
                                      value: metrics?.dailyFatTarget ?? 1,
                                      title: '',
                                      color: AppTheme.primaryOrange,
                                      radius: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMacroLegend(
                                'Protein',
                                '${metrics?.dailyProteinTarget.toInt() ?? 0}g',
                                AppTheme.primaryPurple,
                              ),
                              const SizedBox(height: 8),
                              _buildMacroLegend(
                                'Carbs',
                                '${metrics?.dailyCarbsTarget.toInt() ?? 0}g',
                                AppTheme.primaryBlue,
                              ),
                              const SizedBox(height: 8),
                              _buildMacroLegend(
                                'Fat',
                                '${metrics?.dailyFatTarget.toInt() ?? 0}g',
                                AppTheme.primaryOrange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightLabel(String label, double weight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(
          '${weight.toStringAsFixed(1)} kg',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMacroLegend(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.white54)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getGenderEmoji(gender) {
    if (gender == null) return '👤';
    switch (gender.toString()) {
      case 'Gender.male':
        return '👨';
      case 'Gender.female':
        return '👩';
      default:
        return '🧑';
    }
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.yellow;
    if (bmi < 25) return AppTheme.success;
    if (bmi < 30) return AppTheme.warning;
    return AppTheme.error;
  }

  double _calculateGoalProgress(double current, double target) {
    // Simplified progress calculation
    return 0.3; // Placeholder
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.white70),
              title: const Text('Redo Onboarding', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                await context.read<UserProvider>().resetProfile();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white70),
              title: const Text('About NutriPlan AI', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'NutriPlan AI',
                  applicationVersion: '1.0.0',
                  applicationIcon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.restaurant_menu, color: Colors.white),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
