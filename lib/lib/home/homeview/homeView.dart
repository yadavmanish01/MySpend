import 'package:flutter/material.dart';
import 'package:my_spend/lib/home/addExpenses/addExpensesView.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/Appstyle/appStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

final List<Map<String, dynamic>> _transactions = [
  {
    "title": "Groceries",
    "category": "Food",
    "amount": "-₹1,240",
    "isExpense": true,
    "letter": "G",
  },
  {
    "title": "Salary",
    "category": "Income",
    "amount": "+₹65,000",
    "isExpense": false,
    "letter": "S",
  },
  {
    "title": "Netflix",
    "category": "Bills",
    "amount": "-₹649",
    "isExpense": true,
    "letter": "N",
  },
  {
    "title": "Cab",
    "category": "Travel",
    "amount": "-₹420",
    "isExpense": true,
    "letter": "C",
  },
  {
    "title": "Cafe",
    "category": "Food",
    "amount": "-₹280",
    "isExpense": true,
    "letter": "C",
  },
];

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Good morning, Manish",
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Your finances", style: AppTextStyles.headingLarge),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none),
                  ),
                ],
              ),
              20.ph,
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
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
                      "₹42,580",
                      style: AppTextStyles.headingLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    10.ph,
                    Text(
                      "+ ₹8,240 this month",
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              15.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Income", style: AppTextStyles.captionBold),
                          5.ph,
                          Text("₹65,000", style: AppTextStyles.headingLarge),
                          5.ph,
                          Text(
                            "+12.4%",
                            style: AppTextStyles.captionBold.copyWith(
                              color: AppColors.Success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.pw,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expenses", style: AppTextStyles.captionBold),
                          5.ph,
                          Text("₹22,420", style: AppTextStyles.headingLarge),
                          5.ph,
                          Text(
                            "-4.8%",
                            style: AppTextStyles.captionBold.copyWith(
                              color: AppColors.Error,
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
                prefixIcon: Icons.analytics_outlined,
                title: "Add Expenses",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addexpensesview()),
                  );
                },
              ),
              25.ph,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent transactions",
                    style: AppTextStyles.headingLarge,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: AppTextStyles.headingSmall.copyWith(decoration: TextDecoration.underline,
                        color: AppColors.Error,
                      ),
                    ),
                  ),
                ],
              ),
              35.ph,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                separatorBuilder: (context, index) => 12.ph,
                itemBuilder: (context, index) {
                  final item = _transactions[index];
                  return Container(
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
                            item["letter"],
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
                              Text(
                                item["title"],
                                style: AppTextStyles.headingLarge,
                              ),
                              4.ph,
                              Text(
                                item["category"],
                                style: AppTextStyles.captionBold,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item["amount"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: item["isExpense"]
                                ? const Color(0xFFE53935)
                                : const Color(0xFF27AE60),
                          ),
                        ),
                      ],
                    ),
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
