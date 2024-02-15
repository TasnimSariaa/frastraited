//mod 8 assighnment
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/app_theme_data.dart';
import 'package:frastraited/app.dart';
import 'package:frastraited/screen/onboarding/emailVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/forgotPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/pinVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/registrationScreen.dart';
import 'package:frastraited/screen/onboarding/resetPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/signUpScreen.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.lightThemeData,
      debugShowCheckedModeBanner: false, //also its by default true
      title: "My project",
      initialRoute: '/',
      routes: {
        '/': (context) => splashScreen(),
        '/login': (context) => loginScreen(),
        '/pinVarification': (context) => pinVerificationScreen(),
        '/emailVarification': (context) => emailVerificationScreen(),
        '/registration': (context) => registrationScreen(),
        '/setPassword': (context) => resetPasswordScreen(),
        '/signUp': (context) => signUpScreen(),
        '/forgotPassword': (context) => forgotPasswordScreen(),



      },

    );
  }
}