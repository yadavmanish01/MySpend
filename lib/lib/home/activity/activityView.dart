import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';

import '../../../utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class Activityview extends StatefulWidget {
  const Activityview({super.key});

  @override
  State<Activityview> createState() => _ActivityviewState();
}

class _ActivityviewState extends State<Activityview> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ["All", "Expenses", "Income"];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.ph,
              Text("Transactions", style: AppTextStyles.headingLarge),
              20.ph,
              const CustomFormField(
                prefixIcon: Icon(Icons.search),
                hint: "Search transactions",
              ),
              20.ph,
              Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5D5FEF).withOpacity(0.12)
                            : (index == 1 ? const Color(0xFFFFEAEA) : const Color(0xFFE8F8F0)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF5D5FEF)
                              : (index == 1 ? const Color(0xFFFF5252) : const Color(0xFF27AE60)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              20.ph,
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
                                style: AppTextStyles.captionBold
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
              30.ph,
            ],
          ),
        ),
      ),
    );
  }
}