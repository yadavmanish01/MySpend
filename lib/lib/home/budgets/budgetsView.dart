import 'package:flutter/material.dart';
import 'package:my_spend/lib/home/budgets/budgetDetails/budgetDetailsView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Budgetsview extends StatefulWidget {
  const Budgetsview({super.key});

  @override
  State<Budgetsview> createState() => _BudgetsviewState();
}

class _BudgetsviewState extends State<Budgetsview> {
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
              Text("Budgets", style: AppTextStyles.headingLarge),
              35.ph,
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "October budget",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "₹22,420 / ₹35,000",
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    10.ph,
                    LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 8,
                      backgroundColor: AppColors.Secondary.withOpacity(
                        0.8,
                      ), // inactive color
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white, // active color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
              10.ph,
              ListView.separated(shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Budgetdetailsview()));
                },
                  child: Container(padding: EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text("Food"),Text("₹6,240")],),
                       7.ph, LinearProgressIndicator(
                          value: 0.4,
                          minHeight: 8,
                          backgroundColor: AppColors.textMuted.withOpacity(
                            0.3,
                          ), // inactive color
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary, // active color
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => 15.ph,
                itemCount: 5,
              ),
              100.ph,
              CustomButton(onPressed:(){},title: "Create Budget")
            ],
          ),
        ),
      ),
    );
  }
}
