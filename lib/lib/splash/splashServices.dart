import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/routes/routesName.dart';

class SplashServices {
  final FirebaseAuthService _authService = FirebaseAuthService();

  /// Checks authentication state using Firebase Auth and navigates accordingly.
  void checkAuthentication(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      if (_authService.currentUser != null) {
        context.pushReplacementNamed(Routesname.dashBoard);
      } else {
        context.pushReplacementNamed(Routesname.login);
      }
    });
  }
}
