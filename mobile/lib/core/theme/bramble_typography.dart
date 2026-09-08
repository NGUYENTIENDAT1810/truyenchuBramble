import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrambleTypography {
  // Display Font (Caprasimo)
  static TextStyle displayLarge({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.08,
        color: color,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        height: 1.1,
        color: color,
      );

  static TextStyle displaySmall({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.15,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: color,
      );

  // Body / UI Font (Figtree)
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) => GoogleFonts.figtree(
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) => GoogleFonts.figtree(
        fontSize: 14.5,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.45,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) => GoogleFonts.figtree(
        fontSize: 12.5,
        fontWeight: fontWeight ?? FontWeight.w400,
        height: 1.4,
        color: color,
      );

  static TextStyle labelUppercase({Color? color}) => GoogleFonts.figtree(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.3,
        height: 1.0,
        color: color,
      );

  // Reader Font Families
  static TextStyle readerSerif({
    required double fontSize,
    required double lineHeight,
    Color? color,
  }) =>
      GoogleFonts.lora(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle readerSans({
    required double fontSize,
    required double lineHeight,
    Color? color,
  }) =>
      GoogleFonts.figtree(
        fontSize: fontSize,
        height: lineHeight,
        fontWeight: FontWeight.w400,
        color: color,
      );
}
