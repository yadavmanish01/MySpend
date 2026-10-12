import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/budgets/budgetDetails/budgetDetailsView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Budgetsview extends StatefulWidget {
  const Budgetsview({super.key});

  @override
  State<Budgetsview> createState() => _BudgetsviewState();
}

class _BudgetsviewState extends State<Budgetsview> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  void _showCreateBudgetDialog(BuildContext context, String uid) {
    final categoryController = TextEditingController();
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                final category = categoryController.text.trim();
                final limit = double.tryParse(limitController.text.trim()) ?? 0.0;

                if (category.isNotEmpty && limit > 0) {
                  await _firestoreService.setBudget(
                    uid: uid,
                    category: category,
                    limitAmount: limit,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Budget Set Successfully!"),
                        backgroundColor: AppColors.Success,
                      ),
                    );
                  }
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
    final uid = _authService.currentUser?.uid ?? '';

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text("Budgets", style: AppTextStyles.headingLarge),
              25.ph,
              StreamBuilder<QuerySnapshot>(
                stream: uid.isNotEmpty
                    ? _firestoreService.streamBudgets(uid)
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                          onPressed: () => _showCreateBudgetDialog(context, uid),
                          title: "Create Budget",
                        ),
                      ],
                    );
                  }

                  final docs = snapshot.data!.docs;
                  double totalBudgetLimit = 0.0;
                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    totalBudgetLimit += (data['limitAmount'] as num?)?.toDouble() ?? 0.0;
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
                              "Limit: ₹${totalBudgetLimit.toStringAsFixed(0)}",
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
                        itemCount: docs.length,
                        separatorBuilder: (context, index) => 15.ph,
                        itemBuilder: (context, index) {
                          final item = docs[index].data() as Map<String, dynamic>;
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
                        onPressed: () => _showCreateBudgetDialog(context, uid),
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
    );
  }
}
