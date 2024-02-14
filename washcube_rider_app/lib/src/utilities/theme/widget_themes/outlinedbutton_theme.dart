import 'package:flutter/material.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';

class COutlinedButtonTheme {
  COutlinedButtonTheme._(); //Avoid Creating Instances

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.cBlackColor), // Border color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Button border radius
      ),
    ),
  );
}