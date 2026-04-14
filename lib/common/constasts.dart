import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryOlive =  Color.fromARGB(255, 118, 137, 88);
    static const Color inputFieldGrey = Color.fromARGB(255, 244, 244, 244);
    static const Color textGrey = Color.fromARGB(255, 117, 117, 117);
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
}

class AppSpacing {
  static const double defaultPadding = 24.0;
  static const double borderRadiusLarge = 50.0; 
  static const double borderRadiusSmall = 30.0; 
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
  );
}