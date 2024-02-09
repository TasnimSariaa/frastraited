import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/splash_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';

class Imperial extends StatelessWidget {
  const Imperial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: MaterialColor(
              AppColors.primaryColor.value, AppColors.colorSwatch),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: AppColors.primaryColor,
          ),
          primaryColor: AppColors.primaryColor

      ),

      home: SplashScreen(),
    );
  }
}
