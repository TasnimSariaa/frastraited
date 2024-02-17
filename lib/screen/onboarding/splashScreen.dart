import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/onboarding/frontPage.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  User? user;
  @override
  void initState(){
    super.initState();
    user= FirebaseAuth.instance.currentUser;
  }
  void goToLogin(){
    Future.delayed(Duration(seconds:2)).then((value){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=> const frontPage()),
      (route)=>false);
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
              Image.asset('assets/images/logo.png',width: 120,
                height: 120,),
              const Spacer(),
              const CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 8,),
              const Text('Version 1.0'),
              const SizedBox(height: 8,),



            ],
          ),
        ),
      ),
    );
  }
}
