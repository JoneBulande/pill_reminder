import 'app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // ─── Display ───────────────────────────────────────────
  static final TextStyle display = GoogleFonts.dmSans(
    color: AppColors.ink,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static final TextStyle heading = GoogleFonts.dmSans(
    color: AppColors.ink,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  static final TextStyle headingWhite = GoogleFonts.dmSans(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  // Legacy aliases
  static final TextStyle headingBlue = GoogleFonts.dmSans(
    color: AppColors.primary,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.7,
  );

  static final TextStyle headingRed = GoogleFonts.dmSans(
    color: AppColors.accent,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.7,
  );

  // ─── Sub-heading ───────────────────────────────────────
  static final TextStyle subHeading = GoogleFonts.dmSans(
    color: AppColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static final TextStyle subHeadingBTN1 = GoogleFonts.dmSans(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  // ─── Body ──────────────────────────────────────────────
  static final TextStyle body = GoogleFonts.dmSans(
    color: AppColors.gray500,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.dmSans(
    color: AppColors.gray400,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // ─── Labels & Tags ─────────────────────────────────────
  static final TextStyle label = GoogleFonts.dmSans(
    color: AppColors.gray500,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static final TextStyle tag = GoogleFonts.dmSans(
    color: AppColors.ink,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  static final TextStyle greeting = GoogleFonts.dmSans(
    color: Colors.white.withOpacity(0.55),
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  // ─── Inputs ────────────────────────────────────────────
  static final TextStyle input = GoogleFonts.dmSans(
    color: AppColors.ink,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
}
