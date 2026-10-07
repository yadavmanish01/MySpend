import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_spend/lib/auth/login/loginView.dart';
import '../../services/sessionController.dart';

class SplashServices {

  /// Takes a [BuildContext] as input and navigates to the home screen if the user is authenticated,
  /// otherwise navigates to the login screen after a delay of 2 seconds.
  void checkAuthentication(BuildContext context) async {
    SessionController()
        .getUserFromPreference()
        .then((value) async {
          if (SessionController.isLogin ?? false) {
            Timer(
              Duration(seconds: 2),
                  () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>const Loginview()), // Replace with your Home Widget
                    (route) => false,
              ),
            );
          } else {
            Timer(
               Duration(seconds: 2),
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) =>const Loginview()), // Replace with your Home Widget
                    (route) => false,
              ),
            );
          }
        })
        .onError((error, stackTrace) {
          Timer(
            const Duration(seconds: 2),
            () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Loginview()), // Replace with your Login Widget
                  (route) => false,
            ),
          );
        });
  }
}
