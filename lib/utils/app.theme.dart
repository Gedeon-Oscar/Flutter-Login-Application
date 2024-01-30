import 'package:flutter/material.dart';
import 'package:locallancers/utils/app.colors.dart';

class CustomTheme{

  ThemeData darkTheme(){
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBgColor,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(
        color: AppColors.iconColor,
      ),
      //textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white30))
    );
  }

}