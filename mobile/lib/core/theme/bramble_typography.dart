import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrambleTypography {
  // Display Font (Caprasimo) - For main titles, editorial headings
  static TextStyle displayLarge({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        height: 1.15,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle displaySmall({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 21,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: color,
      );

  static TextStyle titleLarge({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 18.5,
        fontWeight: FontWeight.w400,
        height: 1.25,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.caprasimo(
        fontSize: 16.5,
        fontWeight: FontWeight.w400,
        height: 1.25,
        color: color,
      );

  // Body / UI Font (Figtree) - For interface, metadata, cards
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

  static TextStyle caption({Color? color, FontWeight? fontWeight}) => GoogleFonts.figtree(
        fontSize: 11.5,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.35,
        color: color,
      );

  static TextStyle labelUppercase({Color? color}) => GoogleFonts.figtree(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
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
