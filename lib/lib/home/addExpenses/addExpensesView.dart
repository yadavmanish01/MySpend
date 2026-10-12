import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_spend/data/response/postApiStatus.dart';
import 'package:my_spend/lib/home/addExpenses/bloc/add_expense_bloc.dart';
import 'package:my_spend/lib/home/addExpenses/bloc/add_expense_event.dart';
import 'package:my_spend/lib/home/addExpenses/bloc/add_expense_state.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Addexpensesview extends StatelessWidget {
  const Addexpensesview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddExpenseBloc(),
      child: const _AddExpenseContent(),
    );
  }
}

class _AddExpenseContent extends StatefulWidget {
  const _AddExpenseContent();

  @override
  State<_AddExpenseContent> createState() => _AddExpenseContentState();
}

class _AddExpenseContentState extends State<_AddExpenseContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AddExpenseBloc, AddExpenseState>(
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
                SnackBar(
                  content: Text(state.message.isEmpty
                      ? 'Transaction Saved Successfully!'
                      : state.message),
                  backgroundColor: AppColors.Success,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Transaction", style: AppTextStyles.headingLarge),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                20.ph,
                // Expense / Income Toggle Buttons
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (previous, current) =>
                      previous.isExpense != current.isExpense,
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(const TransactionTypeChangedEvent(true));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: state.isExpense
                                    ? AppColors.Error
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  color: state.isExpense
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        12.pw,
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.read<AddExpenseBloc>().add(
                                    const TransactionTypeChangedEvent(false),
                                  );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !state.isExpense
                                    ? AppColors.Success
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Income",
                                style: TextStyle(
                                  color: !state.isExpense
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                25.ph,
                Text("Amount", style: AppTextStyles.captionBold),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: AppTextStyles.headingLarge,
                  onChanged: (val) {
                    context
                        .read<AddExpenseBloc>()
                        .add(AmountChangedEvent(val));
                  },
                  decoration: InputDecoration(
                    hintText: "₹ 1,240",
                    hintStyle: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                25.ph,
                Text("Category", style: AppTextStyles.captionBold),
                10.ph,
                CustomFormField(
                  controller: _categoryController,
                  hint: "Food, Bills, Travel, Shopping",
                  onChanged: (val) {
                    context
                        .read<AddExpenseBloc>()
                        .add(CategoryChangedEvent(val));
                  },
                ),
                20.ph,
                Text("Notes / Title", style: AppTextStyles.captionBold),
                10.ph,
                CustomFormField(
                  controller: _notesController,
                  maxLines: 3,
                  minLines: 3,
                  hint: "Lunch with team",
                  onChanged: (val) {
                    context
                        .read<AddExpenseBloc>()
                        .add(NotesChangedEvent(val));
                  },
                ),
                35.ph,
                BlocBuilder<AddExpenseBloc, AddExpenseState>(
                  buildWhen: (previous, current) =>
                      previous.postApiStatus != current.postApiStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.postApiStatus == PostApiStatus.loading;
                    return CustomButton(
                      title: isLoading ? "Saving..." : "Save Transaction",
                      onPressed: isLoading
                          ? null
                          : () {
                              context
                                  .read<AddExpenseBloc>()
                                  .add(const SaveExpenseSubmittedEvent());
                            },
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
