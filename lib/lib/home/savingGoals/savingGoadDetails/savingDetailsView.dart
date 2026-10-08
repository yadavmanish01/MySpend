import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';

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
          child: Column(children: [10.ph,Text("Emergency Fund",style: AppTextStyles.headingLarge,)]),
        ),
      ),
    );
  }
}
