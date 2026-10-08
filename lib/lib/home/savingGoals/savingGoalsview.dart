import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/colorStyle/colorStyle.dart';
import '../../../utils/extensions/sizedboxext.dart';

class Savinggoalsview extends StatefulWidget {
  const Savinggoalsview({super.key});

  @override
  State<Savinggoalsview> createState() => _SavinggoalsviewState();
}

class _SavinggoalsviewState extends State<Savinggoalsview> {
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
              Text("Savings Goals", style: AppTextStyles.headingLarge),
              35.ph,
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency Fund",
                          style: AppTextStyles.headingMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹32,000 / ₹50,000",
                              style: AppTextStyles.captionBold.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "64%",
                              style: AppTextStyles.captionBold.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        7.ph,
                        LinearProgressIndicator(
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
                  );
                },
                separatorBuilder: (context, index) => 15.ph,
                itemCount: 5,
              ),
              50.ph,
              CustomButton(title: "Create New Goal",onPressed: (){},),
              50.ph
            ],
          ),
        ),
      ),
    );
  }
}
