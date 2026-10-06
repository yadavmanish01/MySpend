import 'package:flutter/material.dart';
import 'package:my_spend/lib/auth/login/loginView.dart';
import 'lib/splash/splashview.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:Loginview());
  }
}
