import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/data/response/status.dart';
import 'package:my_spend/lib/home/savingGoals/bloc/saving_goals_bloc.dart';
import 'package:my_spend/lib/home/savingGoals/bloc/saving_goals_event.dart';
import 'package:my_spend/lib/home/savingGoals/bloc/saving_goals_state.dart';
import 'package:my_spend/lib/home/savingGoals/savingGoadDetails/savingDetailsView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Savinggoalsview extends StatelessWidget {
  const Savinggoalsview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SavingGoalsBloc()..add(const FetchSavingGoalsEvent()),
      child: const _SavingGoalsContent(),
    );
  }
}

class _SavingGoalsContent extends StatefulWidget {
  const _SavingGoalsContent();

  @override
  State<_SavingGoalsContent> createState() => _SavingGoalsContentState();
}

class _SavingGoalsContentState extends State<_SavingGoalsContent> {
  void _showCreateGoalDialog(BuildContext parentContext) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                final title = titleController.text.trim();
                final target = double.tryParse(targetController.text.trim()) ?? 0.0;

                if (title.isNotEmpty && target > 0) {
                  Navigator.pop(dialogContext);
                  parentContext.read<SavingGoalsBloc>().add(
                        CreateSavingGoalEvent(
                          title: title,
                          targetAmount: target,
                        ),
                      );
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
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SavingGoalsBloc, SavingGoalsState>(
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
                  content: Text("Saving Goal Created!"),
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
                BlocBuilder<SavingGoalsBloc, SavingGoalsState>(
                  builder: (context, state) {
                    if (state.status == Status.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.goals.isEmpty) {
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

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.goals.length,
                      separatorBuilder: (context, index) => 15.ph,
                      itemBuilder: (context, index) {
                        final item =
                            state.goals[index].data() as Map<String, dynamic>;
                        final title = item['title'] ?? 'Goal';
                        final targetAmount =
                            (item['targetAmount'] as num?)?.toDouble() ?? 1.0;
                        final currentAmount =
                            (item['currentAmount'] as num?)?.toDouble() ?? 0.0;
                        final progress =
                            (currentAmount / targetAmount).clamp(0.0, 1.0);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  backgroundColor: AppColors.textMuted
                                      .withValues(alpha: 0.2),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
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
                  onPressed: () => _showCreateGoalDialog(context),
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
