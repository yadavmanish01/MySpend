import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/lib/auth/login/loginView.dart';
import 'package:my_spend/routes/routesName.dart';
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
                  () => context.pushReplacementNamed(Routesname.dashBoard),
            );
          } else {
            Timer(
               Duration(seconds: 2),
              () => context.pushReplacementNamed(Routesname.login),
            );
          }
        })
        .onError((error, stackTrace) {
          Timer(
            const Duration(seconds: 2),
            () => context.pushReplacementNamed(Routesname.login),
          );
        });
  }
}
