import 'dart:ui';

import 'package:evently/core/theming/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class LightTheme extends BaseTheme{
  @override
  Color get bg_color => Color(0XFFF2FEFF);

  @override
  Color get primary_color => Color(0XFF5669FF);

  @override
  Color get text_color => Color(0XFF1C1C1C);

  @override
  Color get text_field_border_color => Color(0XFF7B7B7B);




  @override
  ThemeData get theme_data => ThemeData(
    primaryColor: primary_color,
    hintColor: text_color,
    secondaryHeaderColor: bg_color,
    scaffoldBackgroundColor: bg_color,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: bg_color,
        iconTheme: IconThemeData(
          color: primary_color,
          size: 32.r
        )
      ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primary_color,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary_color,
      shape: CircleBorder(side: BorderSide(color: Colors.white, width: 4.r)),
      elevation: 0,
    ),
    textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(
            fontSize: 24.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),
      titleMedium: GoogleFonts.inter(
        fontSize: 20.sp,
        color: primary_color,
        fontWeight: FontWeight.bold
      ),
        bodyMedium: GoogleFonts.inter(
            fontSize: 16.sp,
            color: text_color,
            fontWeight: FontWeight.w500
        ),
        bodySmall: GoogleFonts.inter(
        fontSize: 14.sp,
        color: Colors.white,
        fontWeight: FontWeight.w500
    )
    )
  );

  

}