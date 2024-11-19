import 'package:template/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static const linearGreen = LinearGradient(
    colors: [
      Color(0xFF59BA51),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // box shadows
  static final boxShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.625),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static TextStyle get kTextStyle8 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 8.sp,
      );

  static TextStyle get kTextStyle10 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 10.sp,
      );

  static TextStyle get kTextStyleHeader10 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 10.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle12 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 12.sp,
      );

  static TextStyle get kTextStyleHeader12 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 12.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle13 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 13.sp,
      );

  static TextStyle get kTextStyleHeader13 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 13.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle14 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 14.sp,
      );

  static TextStyle get kTextStyleHeader14 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 14.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle16 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 16.sp,
      );

  static TextStyle get kTextStyleHeader16 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 16.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle18 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 18.sp,
      );
  static TextStyle get kTextStyle100 => TextStyle(
    color: Colors.white,
    fontFamily: "RB",
    fontSize: 18.sp,
  );

  static TextStyle get kTextStyleHeader18 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 18.sp,
        fontWeight: FontWeight.bold
      );

  static TextStyle get kTextStyle20 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 20.sp,
      );

  static TextStyle get kTextStyleHeader20 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 20.sp,
        fontWeight: FontWeight.bold
      );
  static TextStyle get kTextStyleHeader26 => TextStyle(
      color: Colors.black,
      fontFamily: "bader",
      fontSize: 26.sp,
      fontWeight: FontWeight.bold
  );

  static TextStyle get kTextStyle22 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 22.sp,
      );
  static TextStyle get kTextStyle24 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 24.sp,
    fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyleHeader22 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontWeight: FontWeight.bold,
        fontSize: 22.sp,
      );

  static TextStyle get kTextStyle36 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 36.sp,
      );

  static TextStyle get kTextStyleHeader36 => TextStyle(
        color: Colors.black,
        fontFamily: "bader",
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get kTextStyle59 => TextStyle(
        color: Colors.black,
        fontFamily: "RB",
        fontSize: 59.sp,
      );
}
