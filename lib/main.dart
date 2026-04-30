import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // ✅ Pastikan ini ada
import 'package:jamu_saripah/Provider/cart_provider.dart'; // ✅ Pastikan path bener
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Firebase (Pake options lu yang tadi)
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBymYUiuQeqzolGvFnixdk9-6xGu4ROBRs",
      appId: "1:523756741499:android:da218b19466f56d584d3de",
      messagingSenderId: "523756741499",
      projectId: "jamu-saripah-78774",
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    // ✅ WAJIB DI-WRAP PAKE MULTIPROVIDER BIAR TOMBOL JALAN
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: JamuSaripah(showOnboarding: showOnboarding),
    ),
  );
}

class JamuSaripah extends StatelessWidget {
  final bool showOnboarding;
  const JamuSaripah({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
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
            body: Center(child: CircularProgressIndicator(color: Color(0xFF7E8959))),
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