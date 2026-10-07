import 'package:flutter/material.dart';
import 'package:my_spend/lib/home/dashboard/dashboardView.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              10.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Welcome back", style: AppTextStyles.headingLarge),
              ),
              30.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign in to continue",
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              10.ph,
              CustomFormField(hint: "you@example.com"),
              30.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: AppTextStyles.bodyMuted),
              ),
              10.ph,
              CustomFormField(hint: "you@example.com"),
              30.ph,
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: AppTextStyles.bodyMuted),
              ),
              10.ph,
              CustomFormField(obscureText: true, hint: "******"),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    "Forgot?",
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              30.ph,
              CustomButton(onPressed: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardView()),
              );}, title: "Sign In"),
              15.ph,
              Text("or continue with", style: AppTextStyles.captionBold),
              15.ph,
              TextButton(
                onPressed: () {},
                child: Text(
                  "Google",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
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
