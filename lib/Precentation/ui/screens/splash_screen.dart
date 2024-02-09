import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/assets_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //Icon(Icons.),
            const Spacer(),
            Image.asset('assets/images/logo.png',width: 120,
            height: 120,),
            const Spacer(),
            const CircularProgressIndicator(),
            const SizedBox(height: 8,),
            const Text('Version 1.0'),
            const SizedBox(height: 8,),


            
          ],
        ),
      ),
    );
  }
}
