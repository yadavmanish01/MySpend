import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsObserver get analyticsObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log Custom App Event
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  /// Log User Login
  Future<void> logLogin({String loginMethod = 'email'}) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  /// Log User Sign Up
  Future<void> logSignUp({String signUpMethod = 'email'}) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  /// Log Add Expense
  Future<void> logAddExpense({
    required String category,
    required double amount,
  }) async {
    await _analytics.logEvent(
      name: 'add_expense',
      parameters: {
        'category': category,
        'amount': amount,
      },
    );
  }
}
