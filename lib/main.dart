//mod 8 assighnment
import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.normal,
          ),
        ),
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 10),

  )
),

      ),
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
