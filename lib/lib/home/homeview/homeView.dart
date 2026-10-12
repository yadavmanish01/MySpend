import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/lib/home/addExpenses/addExpensesView.dart';
import 'package:my_spend/lib/home/homeview/bloc/home_bloc.dart';
import 'package:my_spend/lib/home/homeview/bloc/home_event.dart';
import 'package:my_spend/lib/home/homeview/bloc/home_state.dart';
import 'package:my_spend/lib/notification/notificationView.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/Appstyle/appStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const FetchHomeDataEvent()),
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatelessWidget {
  const _HomeViewContent();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService().currentUser;
    final userEmail = user?.email ?? 'User';

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome, ${userEmail.split('@').first}",
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your finances", style: AppTextStyles.headingLarge),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Notificationview(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none),
                  ),
                ],
              ),
              20.ph,
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state.status == Status.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      // Total Balance Card
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total balance",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            10.ph,
                            Text(
                              "₹${state.totalBalance.toStringAsFixed(2)}",
                              style: AppTextStyles.headingLarge.copyWith(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            10.ph,
                            Text(
                              state.totalBalance >= 0
                                  ? "Positive balance"
                                  : "Net negative spending",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.ph,
                      // AI Financial Insight Banner
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B61FF), Color(0xFF5B5CE2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.amber,
                              size: 28,
                            ),
                            12.pw,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "AI Financial Insight",
                                    style: AppTextStyles.captionBold.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  4.ph,
                                  Text(
                                    state.totalExpenses > 0
                                        ? "Total expense recorded: ₹${state.totalExpenses.toStringAsFixed(2)}. Keep track to save more!"
                                        : "No expenses recorded yet. Tap below to add your first transaction!",
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.ph,
                      // Income vs Expense Summary Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Income", style: AppTextStyles.captionBold),
                                  5.ph,
                                  Text(
                                    "₹${state.totalIncome.toStringAsFixed(2)}",
                                    style: AppTextStyles.headingLarge.copyWith(
                                      color: AppColors.Success,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.pw,
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Expenses", style: AppTextStyles.captionBold),
                                  5.ph,
                                  Text(
                                    "₹${state.totalExpenses.toStringAsFixed(2)}",
                                    style: AppTextStyles.headingLarge.copyWith(
                                      color: AppColors.Error,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      25.ph,
                      CustomButton(
                        prefixIcon: Icons.add_circle_outline,
                        title: "Add Transaction",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Addexpensesview(),
                            ),
                          );
                        },
                      ),
                      25.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent transactions",
                            style: AppTextStyles.headingLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              context.goNamed(Routesname.activity);
                            },
                            child: Text(
                              "See All",
                              style: AppTextStyles.headingSmall.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      15.ph,
                      if (state.transactions.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Text(
                            "No transactions found.\nTap 'Add Transaction' to get started!",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMuted,
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.transactions.length > 5
                              ? 5
                              : state.transactions.length,
                          separatorBuilder: (context, index) => 12.ph,
                          itemBuilder: (context, index) {
                            final item = state.transactions[index].data()
                                as Map<String, dynamic>;
                            final title = item['title'] ?? 'Transaction';
                            final category = item['category'] ?? 'General';
                            final amount =
                                (item['amount'] as num?)?.toDouble() ?? 0.0;
                            final isExpense =
                                item['isExpense'] as bool? ?? true;
                            final letter = title.isNotEmpty
                                ? title[0].toUpperCase()
                                : 'T';

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F3FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      letter,
                                      style: AppTextStyles.headingMedium.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  14.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(title,
                                            style: AppTextStyles.headingLarge),
                                        4.ph,
                                        Text(category,
                                            style: AppTextStyles.captionBold),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${isExpense ? '-' : '+'}₹${amount.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isExpense
                                          ? AppColors.Error
                                          : AppColors.Success,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
