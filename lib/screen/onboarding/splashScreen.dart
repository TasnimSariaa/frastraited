import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
    Future.delayed(const Duration(seconds: 4)).then((value) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, isAdmin ? "/adminHome" : "/userHome");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  void _getUser(String uid) async {
    final user = await DatabaseService.instance.getUserInfo(uid);
    setState(() {
      isAdmin = user.userType.toLowerCase() == "admin";
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
                'assets/images/medical1.svg',
                width: 400,
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
