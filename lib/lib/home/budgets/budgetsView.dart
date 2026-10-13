import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/home/budgets/bloc/budgets_bloc.dart';
import 'package:my_spend/lib/home/budgets/bloc/budgets_event.dart';
import 'package:my_spend/lib/home/budgets/bloc/budgets_state.dart';
import 'package:my_spend/lib/home/budgets/budgetDetails/budgetDetailsView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Budgetsview extends StatelessWidget {
  const Budgetsview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetsBloc()..add(const FetchBudgetsEvent()),
      child: const _BudgetsContent(),
    );
  }
}

class _BudgetsContent extends StatefulWidget {
  const _BudgetsContent();

  @override
  State<_BudgetsContent> createState() => _BudgetsContentState();
}

class _BudgetsContentState extends State<_BudgetsContent> {
  void _showCreateBudgetDialog(BuildContext parentContext) {
    final categoryController = TextEditingController();
    final limitController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Set Category Budget", style: AppTextStyles.headingLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomFormField(
                controller: categoryController,
                hint: "Category (e.g. Food, Travel, Bills)",
              ),
              15.ph,
              CustomFormField(
                controller: limitController,
                keyboardType: TextInputType.number,
                hint: "Monthly Limit (e.g. 10000)",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final category = categoryController.text.trim();
                final limit = double.tryParse(limitController.text.trim()) ?? 0.0;

                if (category.isNotEmpty && limit > 0) {
                  Navigator.pop(dialogContext);
                  parentContext.read<BudgetsBloc>().add(
                        CreateBudgetEvent(
                          category: category,
                          limitAmount: limit,
                        ),
                      );
                }
              },
              child: const Text("Save Budget", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<BudgetsBloc, BudgetsState>(
          listenWhen: (previous, current) =>
              previous.postApiStatus != current.postApiStatus,
          listener: (context, state) {
            if (state.postApiStatus == PostApiStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.Error,
                ),
              );
            } else if (state.postApiStatus == PostApiStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Budget Saved Successfully!"),
                  backgroundColor: AppColors.Success,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                Text("Budgets", style: AppTextStyles.headingLarge),
                25.ph,
                BlocBuilder<BudgetsBloc, BudgetsState>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.budgets.isEmpty) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            alignment: Alignment.center,
                            child: Text(
                              "No monthly budgets configured.\nTap 'Create Budget' below to set up limit!",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMuted,
                            ),
                          ),
                          40.ph,
                          CustomButton(
                            onPressed: () => _showCreateBudgetDialog(context),
                            title: "Create Budget",
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        // Total Monthly Budget Summary Card
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Monthly Budget",
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              8.ph,
                              Text(
                                "Limit: ₹${state.totalLimit.toStringAsFixed(0)}",
                                style: AppTextStyles.displayMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              12.ph,
                              LinearProgressIndicator(
                                value: 0.3,
                                minHeight: 8,
                                backgroundColor: AppColors.Secondary.withValues(alpha: 0.8),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                        20.ph,
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.budgets.length,
                          separatorBuilder: (context, index) => 15.ph,
                          itemBuilder: (context, index) {
                            final item = state.budgets[index].data() as Map<String, dynamic>;
                            final category = item['category'] ?? 'Category';
                            final limitAmount = (item['limitAmount'] as num?)?.toDouble() ?? 1.0;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Budgetdetailsview(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(category, style: AppTextStyles.bodyLarge),
                                        Text(
                                          "Limit: ₹${limitAmount.toStringAsFixed(0)}",
                                          style: AppTextStyles.captionBold,
                                        ),
                                      ],
                                    ),
                                    8.ph,
                                    LinearProgressIndicator(
                                      value: 0.2,
                                      minHeight: 8,
                                      backgroundColor: AppColors.textMuted.withValues(alpha: 0.2),
                                      valueColor: const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        40.ph,
                        CustomButton(
                          onPressed: () => _showCreateBudgetDialog(context),
                          title: "Create Budget",
                        ),
                      ],
                    );
                  },
                ),
                30.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
