
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jamu_saripah/hooks/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),

      // ✅ GLOBAL FONT
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
    );
  }
}