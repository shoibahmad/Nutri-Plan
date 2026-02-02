import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/animated_button.dart';
import '../home/home_screen.dart';
import 'steps/gender_step.dart';
import 'steps/age_step.dart';
import 'steps/height_step.dart';
import 'steps/weight_step.dart';
import 'steps/target_weight_step.dart';
import 'steps/goal_speed_step.dart';
import 'steps/activity_step.dart';
import 'steps/dietary_preference_step.dart';
import 'steps/allergy_step.dart';
import 'steps/cuisine_step.dart';
import 'steps/health_focus_step.dart';
import 'steps/lifestyle_step.dart';
import 'steps/budget_step.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: const _OnboardingContent(),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = context.watch<OnboardingProvider>();
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (!onboardingProvider.isFirstStep)
                      IconButton(
                        onPressed: () => onboardingProvider.previousStep(),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Step ${onboardingProvider.currentStep + 1} of ${onboardingProvider.totalSteps}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: onboardingProvider.progress,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryGreen,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Page content
              Expanded(
                child: PageView(
                  controller: onboardingProvider.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    GenderStep(),
                    AgeStep(),
                    HeightStep(),
                    WeightStep(),
                    TargetWeightStep(),
                    GoalSpeedStep(),
                    ActivityStep(),
                    DietaryPreferenceStep(),
                    AllergyStep(),
                    CuisineStep(),
                    HealthFocusStep(),
                    LifestyleStep(),
                    BudgetStep(),
                  ],
                ),
              ),
              // Bottom navigation
              Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedGradientButton(
                  text: onboardingProvider.isLastStep ? 'Get Started' : 'Continue',
                  icon: onboardingProvider.isLastStep ? Icons.check : Icons.arrow_forward,
                  onPressed: () => _handleNext(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNext(BuildContext context) async {
    final onboardingProvider = context.read<OnboardingProvider>();
    final userProvider = context.read<UserProvider>();

    if (onboardingProvider.isLastStep) {
      await userProvider.completeOnboarding();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      onboardingProvider.nextStep();
    }
  }
}
