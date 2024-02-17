import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, "/userHome");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Center(
          child: Column(
            children: [
              //Icon(Icons.),
              const Spacer(),
              Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
              ),
              const Spacer(),
              const CircularProgressIndicator(color: AppColors.primaryColor),
              const SizedBox(height: 8),
              const Text('Version 1.0'),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
