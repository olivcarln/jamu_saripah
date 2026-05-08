import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:jamu_saripah/admin_screen/admin_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBymYUiuQeqzolGvFnixdk9-6xGu4ROBRs",
      appId: "1:523756741499:android:da218b19466f56d584d3de",
      messagingSenderId: "523756741499",
      projectId: "jamu-saripah-78774",
    ),
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
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

      /// 🔥 INI YANG DIPINDAH KE SINI
      routes: {'/login': (context) => const LoginScreen()},

      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),

      home: showOnboarding ? const OnboardingScreen() : const AuthWrapper(),
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
        /// ⏳ Loading awal
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8DA05E)),
            ),
          );
        }

        /// ❌ Belum login
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        /// ✅ Sudah login
        final String uid = snapshot.data!.uid;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, roleSnapshot) {
            /// ⏳ Loading role
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF8DA05E)),
                ),
              );
            }

            /// ✅ Cek role user
            if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
              final data = roleSnapshot.data!.data() as Map<String, dynamic>;

              final String role = data['role'] ?? 'user';

              if (role == 'admin') {
                return const AdminMainScreen();
              }
            }

            /// Default user biasa
            return const MainScreen();
          },
        );
      },
    );
  }
}
