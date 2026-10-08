import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Addexpensesview extends StatefulWidget {
  const Addexpensesview({super.key});

  @override
  State<Addexpensesview> createState() => _AddexpensesviewState();
}

class _AddexpensesviewState extends State<Addexpensesview> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text("Add Expense", style: AppTextStyles.headingLarge),
              30.ph,
              Text("Amount", style: AppTextStyles.captionBold),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyles.headingLarge,
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
              const CustomFormField(hint: "Food"),
              25.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date", style: AppTextStyles.captionBold),
                        10.ph,
                        const CustomFormField(hint: "06 Oct 2026"),
                      ],
                    ),
                  ),
                  16.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time", style: AppTextStyles.captionBold),
                        10.ph,
                        const CustomFormField(hint: "04:00 PM"),
                      ],
                    ),
                  ),
                ],
              ),
              20.ph,
              Text("Notes", style: AppTextStyles.captionBold),
              10.ph,
              CustomFormField(maxLines: 5,minLines: 5,hint: "Lunch with team",),
              50.ph,
              CustomButton(title: "Save Expense",onPressed: (){},),
              30.ph
            ],
          ),
        ),
      ),
    );
  }
}