import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/health_metrics.dart';
import '../services/health_calculator.dart';

class UserProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile();
  HealthMetrics? _healthMetrics;
  bool _isOnboardingComplete = false;

  UserProfile get profile => _profile;
  HealthMetrics? get healthMetrics => _healthMetrics;
  bool get isOnboardingComplete => _isOnboardingComplete;

  UserProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('user_profile');
    _isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    
    if (profileJson != null) {
      _profile = UserProfile.fromJson(json.decode(profileJson));
      _updateHealthMetrics();
      _updateStreak();
    }
    notifyListeners();
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(_profile.toJson()));
    _updateHealthMetrics();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isOnboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await saveProfile();
    notifyListeners();
  }

  void _updateHealthMetrics() {
    _healthMetrics = HealthCalculator.calculateAllMetrics(_profile);
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_profile.lastActiveDate != null) {
      final lastActive = DateTime(
        _profile.lastActiveDate!.year,
        _profile.lastActiveDate!.month,
        _profile.lastActiveDate!.day,
      );
      
      final difference = today.difference(lastActive).inDays;
      
      if (difference == 0) {
        // Same day, no change
      } else if (difference == 1) {
        // Next day, increment streak
        _profile.dayStreak++;
        _profile.lastActiveDate = now;
      } else {
        // More than 1 day gap, reset streak
        _profile.dayStreak = 1;
        _profile.lastActiveDate = now;
      }
    } else {
      // First time user
      _profile.dayStreak = 1;
      _profile.lastActiveDate = now;
    }
  }

  // Update methods for onboarding steps
  void updateGender(Gender gender) {
    _profile.gender = gender;
    notifyListeners();
  }

  void updateDateOfBirth(DateTime dob) {
    _profile.dateOfBirth = dob;
    notifyListeners();
  }

  void updateHeight(double heightCm) {
    _profile.heightCm = heightCm;
    notifyListeners();
  }

  void updateWeight(double weightKg) {
    _profile.weightKg = weightKg;
    notifyListeners();
  }

  void updateTargetWeight(double targetWeightKg) {
    _profile.targetWeightKg = targetWeightKg;
    notifyListeners();
  }

  void updateGoalType(GoalType goalType) {
    _profile.goalType = goalType;
    notifyListeners();
  }

  void updateGoalSpeed(double speedKgPerWeek) {
    _profile.goalSpeedKgPerWeek = speedKgPerWeek;
    notifyListeners();
  }

  void updateActivityLevel(ActivityLevel level) {
    _profile.activityLevel = level;
    notifyListeners();
  }

  void updateDietType(DietType dietType) {
    _profile.dietType = dietType;
    notifyListeners();
  }

  void updateAllergies(List<String> allergies) {
    _profile.allergies = allergies;
    notifyListeners();
  }

  void toggleAllergy(String allergy) {
    if (_profile.allergies.contains(allergy)) {
      _profile.allergies.remove(allergy);
    } else {
      _profile.allergies.add(allergy);
    }
    notifyListeners();
  }

  void updateDislikes(List<String> dislikes) {
    _profile.dislikes = dislikes;
    notifyListeners();
  }

  void toggleDislike(String dislike) {
    if (_profile.dislikes.contains(dislike)) {
      _profile.dislikes.remove(dislike);
    } else {
      _profile.dislikes.add(dislike);
    }
    notifyListeners();
  }

  void updateCuisinePreferences(List<String> cuisines) {
    _profile.cuisinePreferences = cuisines;
    notifyListeners();
  }

  void toggleCuisine(String cuisine) {
    if (_profile.cuisinePreferences.contains(cuisine)) {
      _profile.cuisinePreferences.remove(cuisine);
    } else {
      _profile.cuisinePreferences.add(cuisine);
    }
    notifyListeners();
  }

  void updateHealthFocus(List<String> focus) {
    _profile.healthFocus = focus;
    notifyListeners();
  }

  void toggleHealthFocus(String focus) {
    if (_profile.healthFocus.contains(focus)) {
      _profile.healthFocus.remove(focus);
    } else {
      _profile.healthFocus.add(focus);
    }
    notifyListeners();
  }

  void updateCookingTime(int minutes) {
    _profile.cookingTimeMinutes = minutes;
    notifyListeners();
  }

  void updateKitchenEquipment(List<String> equipment) {
    _profile.kitchenEquipment = equipment;
    notifyListeners();
  }

  void toggleEquipment(String equipment) {
    if (_profile.kitchenEquipment.contains(equipment)) {
      _profile.kitchenEquipment.remove(equipment);
    } else {
      _profile.kitchenEquipment.add(equipment);
    }
    notifyListeners();
  }

  void updateCookingFrequency(int frequency) {
    _profile.cookingFrequencyPerWeek = frequency;
    notifyListeners();
  }

  void updateWeeklyBudget(double budget) {
    _profile.weeklyBudget = budget;
    notifyListeners();
  }

  void incrementStreak() {
    _profile.dayStreak++;
    _profile.lastActiveDate = DateTime.now();
    saveProfile();
  }

  Future<void> resetProfile() async {
    _profile = UserProfile();
    _healthMetrics = null;
    _isOnboardingComplete = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    await prefs.setBool('onboarding_complete', false);
    notifyListeners();
  }
}
