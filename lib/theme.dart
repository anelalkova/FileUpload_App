import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: GoogleFonts.geologica().fontFamily,
  brightness: Brightness.light,
  iconTheme: const IconThemeData(color: Color.fromRGBO(88, 73, 111, 1)),
  primaryColor: const Color.fromRGBO(233, 216, 243, 1),
  scaffoldBackgroundColor: const Color.fromRGBO(242, 235, 251, 1),
  primaryTextTheme: TextTheme(
    titleLarge: TextStyle(
      color: const Color.fromRGBO(88, 73, 111, 1),
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: GoogleFonts.geologica().fontFamily,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
    titleTextStyle: TextStyle(
      color: const Color.fromRGBO(88, 73, 111, 1),
      fontWeight: FontWeight.bold,
      fontSize: 18,
      fontFamily: GoogleFonts.geologica().fontFamily,
    ),
    iconTheme: const IconThemeData(color: Color.fromRGBO(88, 73, 111, 1)),
  ),
);