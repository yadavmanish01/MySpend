import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Scanreceipt extends StatefulWidget {
  const Scanreceipt({super.key});

  @override
  State<Scanreceipt> createState() => _ScanreceiptState();
}

class _ScanreceiptState extends State<Scanreceipt> {
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
              Text("Scan Receipt", style: AppTextStyles.headingLarge),
              20.ph,
              Text("Capture your receipt", style: AppTextStyles.headingLarge),
              Text(
                "We'll extract amount, date and merchant.",
                style: AppTextStyles.captionBold,
              ),
              15.ph,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 50,
                        color: AppColors.primary,
                      ),
                      10.ph,
                      Text(
                        "Align Receipt Inside Frame",
                        style: AppTextStyles.captionBold,
                      ),
                    ],
                  ),
                ),
              ),
              20.ph,
              // AI Extracted Details Preview Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                        8.pw,
                        Text(
                          "AI Extracted Details Preview",
                          style: AppTextStyles.captionBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    12.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Merchant:", style: AppTextStyles.caption),
                        Text("Starbucks Coffee", style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date:", style: AppTextStyles.caption),
                        Text("10 Oct 2026", style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Category:", style: AppTextStyles.caption),
                        Text("Food & Dining", style: AppTextStyles.bodyLarge),
                      ],
                    ),
                    6.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount:", style: AppTextStyles.captionBold),
                        Text("₹450.00", style: AppTextStyles.headingLarge.copyWith(color: AppColors.Success)),
                      ],
                    ),
                  ],
                ),
              ),
              25.ph,
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  prefixIcon: Icons.camera_alt_outlined,
                  width: MediaQuery.of(context).size.width * 0.7,
                  title: "Scan with Gemini AI",
                  onPressed: () {},
                ),
              ),
              15.ph,
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "or choose from gallery",
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
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
