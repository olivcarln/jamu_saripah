import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ Pastikan import ini sesuai dengan struktur folder lu
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBymYUiuQeqzolGvFnixdk9-6xGu4ROBRs",
      appId: "1:523756741499:android:da218b19466f56d584d3de",
      messagingSenderId: "523756741499",
      projectId: "jamu-saripah-78774",
    ),
  );

  // 2. Cek status Onboarding
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    // ✅ MultiProvider dibungkus di sini biar fitur Cart bisa dipake di seluruh app
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
      // ✅ Tentukan mau ke Onboarding atau langsung ke AuthWrapper
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
        // ✅ Kalau user sudah login, lempar ke MainScreen
        if (snapshot.hasData) {
          return const MainScreen(); 
        }
        // ✅ Kalau belum login, lempar ke LoginScreen
        return const LoginScreen(); 
      },
    );
  }
}