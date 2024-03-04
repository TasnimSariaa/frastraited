import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_theme_data.dart';
import 'package:frastraited/admin/screen/home/admin_home_screen.dart';
import 'package:frastraited/firebase_options.dart';
import 'package:frastraited/screen/onboarding/forgotPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/frontPage.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/signUpScreen.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        '/front': (context) => const frontPage(),
        '/signUp': (context) => const signUpScreen(),
        '/forgotPassword': (context) => const forgotPasswordScreen(),
        '/userHome': (context) => const MainBottomNavScreen(),
        '/adminHome': (context) => const AdminHomeScreen(),
      },
    );
  }
}
