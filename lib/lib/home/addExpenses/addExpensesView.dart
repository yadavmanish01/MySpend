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

  final List<Map<String, dynamic>> _categories = [
    {
      "name": "Food",
      "amount": "₹8,240",
      "icon": Icons.fastfood_rounded,
    },
    {
      "name": "Travel",
      "amount": "₹4,580",
      "icon": Icons.directions_car_rounded,
    },
    {
      "name": "Bills",
      "amount": "₹5,000",
      "icon": Icons.receipt_long_rounded,
    },
    {
      "name": "Shopping",
      "amount": "₹3,800",
      "icon": Icons.shopping_bag_rounded,
    },
    {
      "name": "Health",
      "amount": "₹1,920",
      "icon": Icons.medical_services_rounded,
    },
    {
      "name": "Other",
      "amount": "₹880",
      "icon": Icons.more_horiz_rounded,
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showCategoriesBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text(
                "Categories",
                style: AppTextStyles.headingLarge.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E212A),
                ),
              ),
              20.ph,
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final item = _categories[index];
                    final isSelected =
                        _categoryController.text == item["name"];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoryController.text = item["name"];
                        });
                        parentContext.read<AddExpenseBloc>().add(
                              CategoryChangedEvent(item["name"]),
                            );
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEEF2FF),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item["icon"] as IconData,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            10.pw,
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["name"],
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  2.ph,
                                  Text(
                                    item["amount"],
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              15.ph,
              CustomButton(
                title: "Add Category",
                prefixIcon: Icons.add,
                onPressed: () {
                  Navigator.pop(context);
                  _showCustomCategoryDialog(parentContext);
                },
              ),
              15.ph,
            ],
          ),
        );
      },
    );
  }

  void _showCustomCategoryDialog(BuildContext parentContext) {
    final customCategoryController = TextEditingController();

    showDialog(
      context: parentContext,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("New Category", style: AppTextStyles.headingLarge),
          content: CustomFormField(
            controller: customCategoryController,
            hint: "Category Name (e.g. Entertainment)",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () {
                final text = customCategoryController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _categoryController.text = text;
                    _categories.add({
                      "name": text,
                      "amount": "₹0",
                      "icon": Icons.category_rounded,
                    });
                  });
                  parentContext
                      .read<AddExpenseBloc>()
                      .add(CategoryChangedEvent(text));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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
                // Category Picker Field
                InkWell(
                  onTap: () => _showCategoriesBottomSheet(context),
                  borderRadius: BorderRadius.circular(12),
                  child: IgnorePointer(
                    child: CustomFormField(
                      controller: _categoryController,
                      hint: "Select Category (Food, Travel, Bills...)",
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
