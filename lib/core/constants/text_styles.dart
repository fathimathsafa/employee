import 'package:employee/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings
  static final TextStyle heading = GoogleFonts.urbanist(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.cardBackground,
    letterSpacing: 0.15.sp,
  );

  static final TextStyle subheading = GoogleFonts.urbanist(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.15.sp,
  );

  // Body text
  static final TextStyle bodyLarge = GoogleFonts.urbanist(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.5.sp,
  );

  static final TextStyle bodyMedium = GoogleFonts.urbanist(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.25.sp,
  );

  static final TextStyle bodySmall = GoogleFonts.urbanist(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.4.sp,
  );

  // Labels
  static final TextStyle label = GoogleFonts.urbanist(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.1.sp,
  );

  // Buttons
  static final TextStyle button = GoogleFonts.urbanist(
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5.sp,
  );

  static final TextStyle buttonSmall = GoogleFonts.urbanist(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.25.sp,
  );

  // Input fields
  static final TextStyle input = GoogleFonts.urbanist(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.5.sp,
  );

  // Links
  static final TextStyle link = GoogleFonts.urbanist(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    letterSpacing: 0.5.sp,
  );
}
