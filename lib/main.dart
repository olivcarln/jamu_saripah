import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import file sakti hasil konfigurasi tadi
import 'firebase_options.dart'; 

import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';

void main() async {
  // Wajib dipanggil sebelum inisialisasi apapun
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menyalakan Firebase menggunakan konfigurasi otomatis
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Mengambil status onboarding dari memori hp
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
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
      title: 'Jamu Saripah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Mengatur font Montserrat sebagai standar aplikasi
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // Alur: Onboarding -> AuthWrapper (Login/Main)
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
    // StreamBuilder ini gunanya nge-cek: user sudah login atau belum?
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika status login sedang dicek, tampilkan loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8DA05E)), 
            ),
          );
        }
        
        // Jika user sudah login (ada datanya), masuk ke Main Screen
        if (snapshot.hasData) {
          return const MainScreen(); 
        }
        
        // Jika user belum login, lempar ke halaman Login
        return const LoginScreen(); 
      },
    );
  }
}