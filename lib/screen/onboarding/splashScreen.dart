import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  void initState(){
    super.initState();
    goToLogin();
  }

  void goToLogin(){
    Future.delayed(Duration(seconds:4)).then((value){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context)=> const loginScreen()),
      (route)=>false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:BodyBackground(
          child: Center(
            child: SvgPicture.asset('assets/images/medical1.svg',
              width: 400,
              //height: double.infinity,
            ),
          )

      ),
    );
  }
}
