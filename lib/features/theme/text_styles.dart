import 'package:flutter/material.dart';
import '../../core//constants/colors.dart';

class AppTextStyles {
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.text),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.text),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.text),
    
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.text),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.muted),
    
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
  );
}
