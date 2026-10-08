import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
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
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("62%", style: AppTextStyles.displayMedium),
                      Text("used", style: AppTextStyles.captionBold),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
