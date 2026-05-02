import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jamu_saripah/Provider/languange_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// IMPORT FILE PROJECT:
import 'firebase_options.dart'; 
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Cek status Onboarding
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  // 3. Jalankan App dengan Provider
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: JamuSaripah(showOnboarding: showOnboarding),
    ),
  );
}

class JamuSaripah extends StatelessWidget {
  final bool showOnboarding;
  const JamuSaripah({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan bahasa secara global
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jamu Saripah',
      
      // Mengatur bahasa aplikasi secara dinamis
      locale: languageProvider.currentLocale, 

      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        // Warna primer Jamu Saripah
        primaryColor: const Color(0xFF8DA05E), 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8DA05E)),
      ),
      
      // LOGIKA NAVIGASI UTAMA
      home: showOnboarding 
          ? const OnboardingScreen() 
          : const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8DA05E)),
            ),
          );
        }
        
        if (snapshot.hasData) {
          return const MainScreen(); 
        }
        
        return const LoginScreen();
      },
    );
  }
}