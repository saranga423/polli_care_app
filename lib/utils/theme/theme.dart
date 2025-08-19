import 'package:cinec_movie_booking/utils/custom_themes/appbar_theme.dart';
import 'package:cinec_movie_booking/utils/custom_themes/bottom_sheet_theme.dart';
import 'package:cinec_movie_booking/utils/custom_themes/checkbox_theme.dart';
import 'package:cinec_movie_booking/utils/custom_themes/elevated_button_theme.dart';
import 'package:cinec_movie_booking/utils/custom_themes/outlined_button_theme.dart';
import 'package:cinec_movie_booking/utils/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../custom_themes/text_field_theme.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: CTextTheme.lightTextTheme,

    appBarTheme: CAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: CBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: CCheckBoxTheme.lightCheckBoxTheme,
    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
    elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: COutlinedButtonTheme.lightOutlinedButtonTheme,
  );

  //-------------------dark theme------------------//

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: CTextTheme.darkTextTheme,
    appBarTheme: CAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: CBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: CCheckBoxTheme.darkCheckBoxTheme,
    inputDecorationTheme: CTextFormFieldTheme.darkInputDecorationTheme,
    elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: COutlinedButtonTheme.darkOutlinedButtonTheme,
  );
}
