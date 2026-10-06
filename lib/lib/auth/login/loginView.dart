import 'package:flutter/material.dart';
import 'package:my_spend/utils/widgets/customFormField.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomFormField(hint: "you@example.com",),
        ],
      ),
    ),);
  }
}
