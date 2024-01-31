//mod 8 assighnment
import 'package:flutter/material.dart';
import 'package:frastraited/screen/onboarding/emailVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/pinVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/registrationScreen.dart';
import 'package:frastraited/screen/onboarding/setPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';

void main() {
  runApp(
      MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false, //also its by default true
      title: "My project",
      initialRoute: '/',
      routes: {
        '/':(context)=>splashScreen(),
        '/login':(context)=>loginScreen(),
        '/pinVarification':(context)=>pinVerificationScreen(),
        '/emailVarification':(context)=>emailVerificationScreen(),
        '/registration':(context)=>registrationScreen(),
        '/setPassword':(context)=>setPasswoedScreen(),

      },

    );
  }
}

