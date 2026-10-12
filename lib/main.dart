import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/firebase_services/firebase_analytics_service.dart';
import 'package:my_spend/firebase_services/firebase_app_check_service.dart';
import 'package:my_spend/firebase_services/firebase_crashlytics_service.dart';
import 'package:my_spend/firebase_services/firebase_messaging_service.dart';
import 'package:my_spend/firebase_services/firebase_remote_config_service.dart';
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

  // 1. Firebase Core Initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Firebase Crashlytics Service
  await FirebaseCrashlyticsService().initCrashlytics();

  // 3. Firebase App Check Service
  await FirebaseAppCheckService().initAppCheck();

  // 4. Firebase Remote Config Service
  await FirebaseRemoteConfigService().initRemoteConfig();

  // 5. Firebase Messaging Push Notifications
  await FirebaseMessagingService().initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static final FirebaseAnalyticsService _analyticsService =
      FirebaseAnalyticsService();

  final GoRouter _router = GoRouter(
    initialLocation: "/",
    observers: [
      _analyticsService.analyticsObserver,
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
