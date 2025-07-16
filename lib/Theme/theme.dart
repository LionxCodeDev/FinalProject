import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData myTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xfffcfcff),
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.fredoka(
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
      color: const Color(0xff0f1424)
    ),
    bodyMedium: GoogleFonts.fredoka(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0,
      color: const Color(0xff0f1424)
    ),
    bodySmall: GoogleFonts.fredoka(
      fontSize: 13.0,
      letterSpacing: 1.0,
      color: const Color(0xff0f1424)
    ),
    titleMedium: GoogleFonts.bangers(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      color: const Color(0xff0f1424)
    ),
    titleLarge: GoogleFonts.bangers(
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 2.0,
      color: const Color(0xff0f1424)
    ),
    titleSmall: GoogleFonts.bangers(
      fontSize: 13.0,
      letterSpacing: 1.5,
      color: const Color(0xff0f1424)
    ),
    labelLarge: GoogleFonts.karla(
      fontSize: 20.0,
            fontWeight: FontWeight.w300,
            color: Colors.white
    ),
    labelMedium: GoogleFonts.karla(
      fontSize: 14.0,
            fontWeight: FontWeight.w200,
            color: Colors.white
    ),
    labelSmall: GoogleFonts.karla(
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
      color: const Color(0xFFCC9932)
    ),
    displayLarge: GoogleFonts.karla(
      fontSize: 20.0,
      fontWeight: FontWeight.w400,
      color: const Color(0xff0f1424)
    ),
    displayMedium: GoogleFonts.karla(
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: const Color(0xff0f1424)
    )
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: const Color(0XFFC0CCA4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        collapsedBackgroundColor: Colors.grey[400],
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff3b4e5b), width: 1), // Color al enfocar
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xff3b4e5b), width: 1), // Borde normal
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFBCC9932), width: 1),
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFBCC9932), width: 1)
      ),
      filled: true,
      fillColor: Colors.transparent,
      hintStyle: const TextStyle(
        fontFamily: 'karla', // Fuente para los hints
        fontSize: 13,
        color:Color(0x800F1424),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'karla', // Fuente para los labels
        fontSize: 12,
        color: Color(0x800F1424),
      ),
      errorStyle: const TextStyle(
          fontFamily: "Poppins", color: Color(0xff8F8B84), fontSize: 10.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xffcc9932),
      elevation: 5.0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 14.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5
      ),
      selectedIconTheme: const IconThemeData(
        color: Colors.white,
        size: 25,
        opacity: 1.0
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.white,
        size: 15,
        opacity: 0.6
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
    thumbColor: WidgetStateProperty.all(const Color(0xff91A56E)), // color de la barra
    thickness: WidgetStateProperty.all(6), // grosor
    radius: const Radius.circular(5), // bordes redondeados
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: const Color(0xFFCC9932),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            disabledBackgroundColor: const Color(0x800F1424), // Color de fondo
            textStyle: GoogleFonts.karla(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w500))),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFFCC9932),
    contentTextStyle: GoogleFonts.karla(
      color: Colors.white,
      fontSize: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    behavior: SnackBarBehavior.floating,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFFCC9932)), // color del texto
      textStyle: WidgetStateProperty.all<TextStyle>(
        GoogleFonts.bangers(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
          letterSpacing: 1,
        )
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      overlayColor: WidgetStateProperty.all<Color>(const Color(0xFFCC9932).withOpacity(0.1)), // color al presionar
    ),
  ),             
);