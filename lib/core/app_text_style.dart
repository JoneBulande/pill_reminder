import 'app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // 
  static final TextStyle heading = GoogleFonts.nunitoSans(
    color: AppColors.gray100,
    height: 1.3,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle headingRed = GoogleFonts.nunitoSans(
    color: AppColors.redBase,
    height: 1.3,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle headingBlue = GoogleFonts.nunitoSans(
    color: AppColors.blueBase,
    height: 1.3,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle subHeading = GoogleFonts.nunitoSans(
    color: AppColors.gray100,
    height: 1.3,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle subHeadingBTN1 = GoogleFonts.nunitoSans(
    color: AppColors.gray800,
    height: 1.3,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle input = GoogleFonts.nunitoSans(
    color: AppColors.gray200,
    height: 1.3,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle label = GoogleFonts.nunitoSans(
    color: AppColors.gray100,
    height: 1.3,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.nunitoSans(
    // color: AppColors.contentPrimary,
    height: 1.3,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle tag = GoogleFonts.nunitoSans(
    color: AppColors.gray200,
    height: 1.3,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );


}