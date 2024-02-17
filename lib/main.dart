
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/home_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_theme_data.dart';
import 'package:frastraited/firebase_options.dart';
import 'package:frastraited/screen/onboarding/emailVerificationScreen.dart';
import 'package:frastraited/screen/onboarding/forgotPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/registrationScreen.dart';
import 'package:frastraited/screen/onboarding/signUpScreen.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';


import 'Precentation/ui/screens/main_bottom_nav_screen.dart';

void main() async {
  ///
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
    User? user;
    @override
    void initState(){
      super.initState();
      user= FirebaseAuth.instance.currentUser;
    }

    return MaterialApp(
      theme: AppThemeData.lightThemeData,
      debugShowCheckedModeBanner: false,
      title: "My project",
      initialRoute: user!= null ? "/" : '/userHome',
      routes: {
        '/': (context) => const splashScreen(),
        '/login': (context) => const loginScreen(),
        '/emailVarification': (context) => const emailVerificationScreen(),
        '/registration': (context) => const registrationScreen(),
        '/signUp': (context) => const signUpScreen(),
        '/forgotPassword': (context) => const forgotPasswordScreen(),
        '/userHome' : (context) => const MainBottomNavScreen(admin: false,),
      },
      //home: user!= null ? const HomeScreen(admin: true) : const loginScreen()
    );
  }
}
