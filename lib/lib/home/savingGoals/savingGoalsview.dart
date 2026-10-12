import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_spend/firebase_services/firebase_auth_service.dart';
import 'package:my_spend/firebase_services/firestore_service.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoadDetails/savingDetailsView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class Savinggoalsview extends StatefulWidget {
  const Savinggoalsview({super.key});

  @override
  State<Savinggoalsview> createState() => _SavinggoalsviewState();
}

class _SavinggoalsviewState extends State<Savinggoalsview> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  void _showCreateGoalDialog(BuildContext context, String uid) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Create Saving Goal", style: AppTextStyles.headingLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomFormField(
                controller: titleController,
                hint: "Goal Title (e.g. New Laptop)",
              ),
              15.ph,
              CustomFormField(
                controller: targetController,
                keyboardType: TextInputType.number,
                hint: "Target Amount (e.g. 50000)",
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
                final title = titleController.text.trim();
                final target = double.tryParse(targetController.text.trim()) ?? 0.0;

                if (title.isNotEmpty && target > 0) {
                  await _firestoreService.addSavingGoal(
                    uid: uid,
                    title: title,
                    targetAmount: target,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Saving Goal Created!"),
                        backgroundColor: AppColors.Success,
                      ),
                    );
                  }
                }
              },
              child: const Text("Create", style: TextStyle(color: Colors.white)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Savings Goals", style: AppTextStyles.headingLarge),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              20.ph,
              StreamBuilder<QuerySnapshot>(
                stream: uid.isNotEmpty
                    ? _firestoreService.streamSavingGoals(uid)
                    : const Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                        "No savings goals set yet.\nTap 'Create New Goal' below to start!",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => 15.ph,
                    itemBuilder: (context, index) {
                      final item = docs[index].data() as Map<String, dynamic>;
                      final title = item['title'] ?? 'Goal';
                      final targetAmount = (item['targetAmount'] as num?)?.toDouble() ?? 1.0;
                      final currentAmount = (item['currentAmount'] as num?)?.toDouble() ?? 0.0;
                      final progress = (currentAmount / targetAmount).clamp(0.0, 1.0);
                      final percentage = (progress * 100).toStringAsFixed(0);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Savingdetailsview(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: AppTextStyles.headingMedium),
                              8.ph,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "₹${currentAmount.toStringAsFixed(0)} / ₹${targetAmount.toStringAsFixed(0)}",
                                    style: AppTextStyles.captionBold,
                                  ),
                                  Text(
                                    "$percentage%",
                                    style: AppTextStyles.captionBold.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              10.ph,
                              LinearProgressIndicator(
                                value: progress,
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
                  );
                },
              ),
              40.ph,
              CustomButton(
                title: "Create New Goal",
                onPressed: () => _showCreateGoalDialog(context, uid),
              ),
              30.ph,
            ],
          ),
        ),
      ),
    );
  }
}
