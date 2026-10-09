import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';

import '../../../../utils/extensions/sizedboxext.dart';

class Savingdetailsview extends StatefulWidget {
  const Savingdetailsview({super.key});

  @override
  State<Savingdetailsview> createState() => _SavingdetailsviewState();
}

class _SavingdetailsviewState extends State<Savingdetailsview> {
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
              Text("Emergency Fund", style: AppTextStyles.headingLarge),
              20.ph,
              Align(
                alignment: Alignment.center,
                child: Text("₹32,000", style: AppTextStyles.displayLarge),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "of ₹50,000",
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              10.ph,
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: LinearProgressIndicator(
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
                ),
              ),
              30.ph,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Target date", style: AppTextStyles.headingSmall.copyWith(color: AppColors.textMuted)),
                  Text("31 Dec 2026", style: AppTextStyles.headingSmall),
                ],
              ),
              10.ph,  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Monthly contribution", style: AppTextStyles.headingSmall.copyWith(color: AppColors.textMuted)),
                  Text("₹6,000", style: AppTextStyles.headingSmall),
                ],
              ),
              20.ph,
              Text("Recent contributions",style: AppTextStyles.headingMedium,),
              20.ph,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (context, index) => 12.ph,
                itemBuilder: (context, index) {
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
                              Text(
                               "Groceries",
                                style: AppTextStyles.headingLarge,
                              ),
                              4.ph,
                              Text(
                                 "Food",
                                  style: AppTextStyles.captionBold
                              ),
                            ],
                          ),
                        ),
                        Text(
                        "-1,240",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE53935)

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
