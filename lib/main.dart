import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'lib/auth/login/loginView.dart';
import 'lib/auth/signup/signupView.dart';
import 'lib/home/activity/activityView.dart';
import 'lib/home/addExpenses/addExpensesView.dart';
import 'lib/home/budgets/budgetDetails/budgetDetailsView.dart';
import 'lib/home/budgets/budgetsView.dart';
import 'lib/home/dashboard/dashboardView.dart';
import 'lib/home/homeview/homeView.dart';
import 'lib/home/profile/profileView.dart';
import 'lib/home/savingGoals/savingGoadDetails/savingDetailsView.dart';
import 'lib/home/savingGoals/savingGoalsview.dart';
import 'lib/home/scanReceipt/scanReceipt.dart';
import 'lib/notification/notificationView.dart';
import 'lib/splash/splashview.dart';
import 'routes/routesName.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 1. Firebase App Check (Debug aur Release dono handle karega)
  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode
        ? AppleProvider.debug
        : AppleProvider.deviceCheck,
  );

  // Firebase Remote Config Setup
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      // Debug me 0 rakhein taaki console changes turant mil jayein
      minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
    ),
  );
  // Default values jo fetch fail hone par kaam karengi
  await remoteConfig.setDefaults(const {
    'maintenance_mode': false,
    'app_version_name': '1.0.0',
  });
  await remoteConfig.fetchAndActivate();

  // 3. Crashlytics Error Handling
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Analytics instance
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // GoRouter ke sath Analytics Observer connect karein taaki route navigation automatically track ho
  final GoRouter _router = GoRouter(
    initialLocation: "/",
    observers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],
    routes: [
      GoRoute(
        name: Routesname.splash,
        path: "/",
        builder: ((context, state) => const Splashview()),
      ),
      GoRoute(
        name: Routesname.login,
        path: "/login",
        builder: ((context, state) => const Loginview()),
      ),
      GoRoute(
        name: Routesname.signup,
        path: "/signup",
        builder: ((context, state) => const Signup()),
      ),
      GoRoute(
        name: Routesname.profile,
        path: "/profile",
        builder: ((context, state) => const Profileview()),
      ),
      GoRoute(
        name: Routesname.budgets,
        path: "/budget",
        builder: ((context, state) => const Budgetsview()),
        routes: [
          GoRoute(
            name: Routesname.budgetDetailsView,
            path: "budgetDetails",
            builder: ((context, state) => const Budgetdetailsview()),
          ),
        ],
      ),
      GoRoute(
        name: Routesname.dashBoard,
        path: "/dashboard",
        builder: ((context, state) => const DashboardView()),
      ),
      GoRoute(
        name: Routesname.home,
        path: "/home",
        builder: ((context, state) => const HomeView()),
      ),
      GoRoute(
        name: Routesname.activity,
        path: "/activity",
        builder: ((context, state) => const Activityview()),
      ),
      GoRoute(
        name: Routesname.addExpenses,
        path: "/addExpenses",
        builder: ((context, state) => const Addexpensesview()),
      ),
      GoRoute(
        name: Routesname.savingGoals,
        path: "/savingGoals",
        builder: ((context, state) => const Savinggoalsview()),
        routes: [
          GoRoute(
            name: Routesname.savingGoalDetails,
            path: "savingGoalDetails",
            builder: ((context, state) => const Savingdetailsview()),
          ),
        ],
      ),
      GoRoute(
        name: Routesname.notification,
        path: "/notification",
        builder: ((context, state) => const Notificationview()),
      ),
      GoRoute(
        name: Routesname.scanReceipt,
        path: "/scanReceipt",
        builder: ((context, state) => const Scanreceipt()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}