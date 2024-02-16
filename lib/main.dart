import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_theme_data.dart';
import 'package:frastraited/firebase_options.dart';
import 'package:frastraited/screen/onboarding/forgotPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/pinVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/registrationScreen.dart';
import 'package:frastraited/screen/onboarding/resetPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/signUpScreen.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';

void main() async {
  ///
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.lightThemeData,
      debugShowCheckedModeBanner: false,
      title: "My project",
      initialRoute: '/',
      routes: {
        '/': (context) => const splashScreen(),
        '/login': (context) => const loginScreen(),
        '/pinVarification': (context) => const pinVerificationScreen(),
        '/registration': (context) => const registrationScreen(),
        '/setPassword': (context) => const resetPasswordScreen(),
        '/signUp': (context) => const signUpScreen(),
        '/forgotPassword': (context) => const forgotPasswordScreen(),
      },
    );
  }
}
