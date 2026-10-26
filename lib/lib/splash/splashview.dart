import 'package:flutter/material.dart';
import 'package:my_spend/lib/splash/splashServices.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';
import 'package:my_spend/utils/colorStyle/colorStyle.dart';
import 'package:my_spend/utils/extensions/sizedboxext.dart';

class Splashview extends StatefulWidget {
  const Splashview({super.key});

  @override
  State<Splashview> createState() => _SplashviewState();
}

class _SplashviewState extends State<Splashview> {

  @override
  void initState() {
    super.initState();
    SplashServices().checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),
            20.ph,
            Text(
              "MySpend",
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            8.ph,
            Text(
              "Track smarter. Live better.",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
