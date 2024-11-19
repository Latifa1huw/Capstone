import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSize {
  static void initCurrent({
    required MediaQueryData mediaQueryData,
  }) {
    currentScreenHeight = mediaQueryData.size.height;
    currentScreenWidth = mediaQueryData.size.width;
    currentScreenTopPadding = mediaQueryData.padding.top;
  }

  /// Height
  static late double currentScreenHeight;
  static late double currentScreenTopPadding;
  static double screenHeight = 842;
  static double navBarHeight = 70.0.sp;
  static final h723 = 723.h;
  static final h400 = 400.h;
  static final h420 = 420.h;
  static final h450 = 450.h;
  static final h370 = 370.h;
  static final h350 = 350.h;
  static final h330 = 330.h;
  static final h310 = 310.h;
  static final h300 = 300.h;
  static final h294 = 294.h;
  static final h285 = 285.h;
  static final h280 = 280.h;
  static final h262 = 262.h;
  static final h255 = 255.h;
  static final h240 = 240.h;
  static final h224 = 224.h;
  static final h220 = 220.h;
  static final h210 = 210.h;
  static final h186 = 186.h;
  static final h195 = 195.h;
  static final h190 = 190.h;
  static final h180 = 180.h;
  static final h175 = 175.h;
  static final h170 = 170.h;
  static final h166 = 166.h;
  static final h160 = 160.h;
  static final h157 = 157.h;
  static final h147 = 147.h;
  static final h138 = 138.h;
  static final h135 = 135.h;
  static final h124 = 124.h;
  static final h118 = 118.h;
  static final h116 = 116.h;
  static final h100 = 100.h;
  static final h96 = 96.h;
  static final h91 = 91.h;
  static final h90 = 90.h;
  static final h85 = 85.h;
  static final h82 = 82.h;
  static final h80 = 80.h;
  static final h79 = 79.h;
  static final h76 = 76.h;
  static final h72 = 72.h;
  static final h71 = 71.h;
  static final h68 = 68.h;
  static final h64 = 64.h;
  static final h61 = 61.h;
  static final h62 = 62.h;
  static final h60 = 60.h;
  static final h58 = 58.h;
  static final h56 = 56.h;
  static final h53 = 53.h;
  static final h50 = 50.h;
  static final h49 = 49.h;
  static final h48 = 48.h;
  static final h47 = 47.h;
  static final h45 = 45.h;
  static final h44 = 44.h;
  static final h43 = 43.h;
  static final h40 = 40.h;
  static final h39 = 39.h;
  static final h38 = 38.h;
  static final h37 = 37.h;
  static final h36 = 36.h;
  static final h35 = 35.h;
  static final h34 = 34.h;
  static final h32 = 32.h;
  static final h30 = 30.h;
  static final h29 = 29.h;
  static final h28 = 28.h;
  static final h27 = 27.h;
  static final h26 = 26.h;
  static final h25 = 25.h;
  static final h24 = 24.h;
  static final h22 = 22.h;
  static final h21 = 21.h;
  static final h20 = 20.h;
  static final h18 = 18.h;
  static final h17 = 17.h;
  static final h16 = 16.h;
  static final h15 = 15.h;
  static final h14 = 14.h;
  static final h13 = 13.h;
  static final h12 = 12.h;
  static final h11 = 11.h;
  static final h10 = 10.h;
  static final h9 = 9.h;
  static final h8 = 8.h;
  static final h7 = 7.h;
  static final h6 = 6.h;
  static final h5 = 5.h;
  static final h4 = 4.h;
  static final h3 = 3.h;
  static final h2 = 2.h;
  static final h1 = 1.h;

  /// Width
  static late double currentScreenWidth;
  static double screenWidth = 390;
  static final w318 = 318.w;
  static final w295 = 295.w;
  static final w243 = 243.w;
  static final w180 = 180.w;
  static final w120 = 120.w;
  static final w100 = 100.w;
  static final w93 = 93.w;
  static final w83 = 83.w;
  static final w77 = 77.w;
  static final w75 = 75.w;
  static final w68 = 68.w;
  static final w62 = 62.w;
  static final w55 = 55.w;
  static final w50 = 50.w;
  static final w45 = 45.w;
  static final w43 = 43.w;
  static final w36 = 36.w;
  static final w32 = 32.w;
  static final w29 = 29.w;
  static final w28 = 28.w;
  static final w27 = 27.w;
  static final w26 = 26.w;
  static final w24 = 24.w;
  static final w23 = 23.w;
  static final w22 = 22.w;
  static final w20 = 20.w;
  static final w18 = 18.w;
  static final w17 = 17.w;
  static final w16 = 16.w;
  static final w15 = 15.w;
  static final w14 = 14.w;
  static final w13 = 13.w;
  static final w12 = 12.w;
  static final w11 = 11.w;
  static final w10 = 10.w;
  static final w9 = 9.w;
  static final w8 = 8.w;
  static final w7 = 7.w;
  static final w6 = 6.w;
  static final w5 = 5.w;
  static final w4 = 4.w;
  static final w3 = 3.w;
  static final w2 = 2.w;
  static final w1 = 1.w;

  /// sp
  static final sp220 = 220.sp;
  static final sp200 = 200.sp;
  static final sp255 = 255.sp;
  static final sp180 = 180.sp;
  static final sp133 = 133.sp;
  static final sp117 = 117.sp;
  static final sp111 = 111.sp;
  static final sp100 = 100.sp;
  static final sp92 = 92.sp;
  static final sp79 = 79.sp;
  static final sp72 = 72.sp;
  static final sp71 = 71.sp;
  static final sp63 = 63.sp;
  static final sp55 = 55.sp;
  static final sp50 = 50.sp;
  static final sp48 = 48.sp;
  static final sp43 = 43.sp;
  static final sp42 = 42.sp;
  static final sp40 = 40.sp;
  static final sp38 = 38.sp;
  static final sp36 = 36.sp;
  static final sp32 = 32.sp;
  static final sp28 = 28.sp;
  static final sp24 = 24.sp;
  static final sp22 = 22.sp;
  static final sp21 = 21.sp;
  static final sp20 = 20.sp;
  static final sp16 = 16.sp;
  static final sp14 = 14.sp;
  static final sp11 = 11.sp;
  static final sp10 = 10.sp;
  static final sp5 = 5.sp;
  static final sp4 = 4.sp;

  /// radius
  static final r48 = 48.r;
  static final r37 = 37.r;
  static final r34 = 34.r;
  static final r30 = 30.r;
  static final r26 = 26.r;
  static final r23 = 23.r;
  static final r20 = 20.r;
  static final r18 = 18.r;
  static final r16 = 16.r;
  static final r14 = 14.r;
  static final r12 = 12.r;
  static final r11 = 11.r;
  static final r10 = 10.r;
  static final r9 = 9.r;
  static final r8 = 8.r;
  static final r7 = 7.r;
  static final r6 = 6.r;

  /// absolute
  static const double a572 = 572;
  static const double a483 = 483;
  static const double a412 = 412;
  static const double a551 = 551;
  static const double a322 = 322;
  static const double a298 = 298;
  static const double a230 = 230;
  static const double a191 = 191;
  static const double a120 = 120;
  static const double a55 = 55;
  static const double a50 = 50;
  static const double a42 = 42.0;
  static const double a30 = 30.0;
  static const double a20 = 20.0;
  static const double a18 = 18.0;
  static const double a10 = 10;
  static const double a4 = 4;
  static const double a2 = 2;
  static const double a1 = 1;
}