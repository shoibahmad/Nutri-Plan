import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentStep = 0;
  final int totalSteps = 13;
  final PageController pageController = PageController();

  int get currentStep => _currentStep;
  double get progress => (_currentStep + 1) / totalSteps;
  bool get isFirstStep => _currentStep == 0;
  bool get isLastStep => _currentStep == totalSteps - 1;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
