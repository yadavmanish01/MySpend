import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import '../../../../utils/extensions/sizedboxext.dart';

class Budgetdetailsview extends StatefulWidget {
  const Budgetdetailsview({super.key});

  @override
  State<Budgetdetailsview> createState() => _BudgetdetailsviewState();
}

class _BudgetdetailsviewState extends State<Budgetdetailsview> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text("Food Budget", style: AppTextStyles.headingLarge),
              30.ph,
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: AppColors.Secondary.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "62%",
                        style: AppTextStyles.displayMedium.copyWith(
                          color: (AppColors.primary),
                        ),
                      ),
                      Text("used", style: AppTextStyles.captionBold),
                    ],
                  ),
                ),
              ),
              30.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  15.pw,
                  Text("Spent", style: AppTextStyles.bodyLarge),
                  Spacer(),
                  Text("₹6,240", style: AppTextStyles.headingMedium),
                  15.pw,
                ],
              ),
              10.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  15.pw,
                  Text("Remaining", style: AppTextStyles.bodyLarge),
                  Spacer(),
                  Text(
                    "₹3,270",
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColors.Success,
                    ),
                  ),
                  15.pw,
                ],
              ),
              20.ph,
              Text("Recent food expenses", style: AppTextStyles.headingMedium),
              15.ph,
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                        "G",
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
                          Text("Groceries", style: AppTextStyles.headingLarge),
                          4.ph,
                          Text("Food", style: AppTextStyles.captionBold),
                        ],
                      ),
                    ),
                    Text(
                      "1,240",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
              15.ph,
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                        "G",
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
                          Text("Groceries", style: AppTextStyles.headingLarge),
                          4.ph,
                          Text("Food", style: AppTextStyles.captionBold),
                        ],
                      ),
                    ),
                    Text(
                      "1,240",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
