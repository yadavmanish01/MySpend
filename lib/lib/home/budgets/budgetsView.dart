import 'package:flutter/material.dart';
import 'package:my_spend/utils/Appstyle/appStyle.dart';

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
          child: Column(children: [10.ph, Text("Budgets",style: AppTextStyles.headingLarge,)]),
        ),
      ),
    );
  }
}
