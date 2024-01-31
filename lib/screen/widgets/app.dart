import 'package:flutter/material.dart';
import 'package:frastraited/screen/onboarding/splashScreen.dart';

class HospitalManagementApp extends StatelessWidget {
  const HospitalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const splashScreen(),

    );
  }
}
