import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Future.delayed(const Duration(seconds: 4)).then((value) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, "/userHome");
      } else {
        Navigator.pushReplacementNamed(context, "/front");
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
              SvgPicture.asset(
                'assets/images/research.svg',
                height: 220,
                width: 220,
                //height: double.infinity,
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
