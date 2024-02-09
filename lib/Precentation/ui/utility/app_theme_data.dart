import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';

class AppThemeData{
  static ThemeData lightThemeData =ThemeData(
    primarySwatch: MaterialColor(
        AppColors.primaryColor.value, AppColors.colorSwatch
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.white60,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),


    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.normal,
      ),
      bodySmall:TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      ),
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14),

        backgroundColor: AppColors.primaryColor,
        textStyle: TextStyle(color: Colors.white), // Text color
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
      foregroundColor: Colors.blueGrey,

      ),
    ),

  );
}