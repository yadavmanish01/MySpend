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
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              35.ph,
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  prefixIcon: Icons.camera_alt_outlined,
                  width: MediaQuery.of(context).size.width * 0.5,
                  title: "Scan Receipt",
                  onPressed: () {},
                ),
              ),
              15.ph,
              Align(alignment: Alignment.center,
                child: Text(
                  "or choose from gallery",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,color: AppColors.primary
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
