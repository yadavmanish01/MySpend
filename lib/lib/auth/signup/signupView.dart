import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_spend/lib/home/dashboard/dashboardView.dart';
import 'package:my_spend/routes/routesName.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';
import 'package:my_spend/utils/widgets/custom_button.dart';

import '../../../utils/extensions/sizedboxext.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
                  "Sign up to continue",
                  style: AppTextStyles.bodyMuted,
                ),
              ),
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
              80.ph,
              CustomButton(
                onPressed: () {
                  context.goNamed(Routesname.dashBoard);
                },
                title: "Sign Up",
              ),
              15.ph,
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",style: AppTextStyles.headingSmall,),
                  TextButton(
                    onPressed: () {context.goNamed(Routesname.login);},
                    child: Text(
                      "Sign In",
                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
