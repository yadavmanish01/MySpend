import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/lib/auth/login/loginView.dart';
import 'package:my_spend/lib/home/activity/activityView.dart';
import 'package:my_spend/lib/home/addExpenses/addExpensesView.dart';
import 'package:my_spend/lib/home/budgets/budgetDetails/budgetDetailsView.dart';
import 'package:my_spend/lib/home/budgets/budgetsView.dart';
import 'package:my_spend/lib/home/dashboard/dashboardView.dart';
import 'package:my_spend/lib/home/homeview/homeView.dart';
import 'package:my_spend/lib/home/profile/profileView.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoadDetails/savingDetailsView.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoalsview.dart';
import 'package:my_spend/lib/home/scanReceipt/scanReceipt.dart';
import 'package:my_spend/lib/notification/notificationView.dart';
import 'package:my_spend/routes/routesName.dart';
import 'lib/splash/splashview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

  ///GoRouter.of(context).go("/profile")
  /// shortcut  - context.go("/")

  /// passing params
  /// GoRoute(path:"/home/:"name",builder: ((context,state)=>const HomeView(
  /// name:state.params["name"]))
  final GoRouter _router = GoRouter(
    initialLocation: "/",
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
        name: Routesname.profile,
        path: "/profile",
        builder: ((context, state) => const Profileview()),
      ),
      GoRoute(
        name: Routesname.budgets,
        path: "/budget",
        builder: ((context, state) => const Budgetsview()),
        routes: [ GoRoute(
          name: Routesname.budgetDetailsView,
          path: "budgetDetails",
          builder: ((context, state) => const Budgetdetailsview()),
        ),]
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
      ),GoRoute(
        name: Routesname.addExpenses,
        path: "/addExpenses",
        builder: ((context, state) => const Addexpensesview()),
      ),GoRoute(
        name: Routesname.savingGoals,
        path: "/savingGoals",
        builder: ((context, state) => const Savinggoalsview()),
        routes: [GoRoute(
          name: Routesname.savingGoalDetails,
          path: "savingGoalDetails",
          builder: ((context, state) => const Savingdetailsview()),
        ),]
      ),GoRoute(
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
}
