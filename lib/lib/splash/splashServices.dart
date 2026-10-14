import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/services/localStorage.dart';

class SplashServices {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final LocalStorage _localStorage = LocalStorage();

  /// Checks authentication state and onboarding status then, navigates.
  void checkAuthentication(BuildContext context) async {
    final completedOnboarding = await _localStorage.readValue('onboarding_completed');

    Timer(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      if (completedOnboarding != 'true') {
        context.pushReplacementNamed(Routesname.onboarding);
      } else if (_authService.currentUser != null) {
        context.pushReplacementNamed(Routesname.dashBoard);
      } else {
        context.pushReplacementNamed(Routesname.login);
      }
    });
  }
}
