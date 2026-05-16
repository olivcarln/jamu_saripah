import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jamu_saripah/Provider/cart_provider.dart';
import 'package:jamu_saripah/provider/auth_user_provider.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart'; 
import 'package:jamu_saripah/hooks/onBoarding/onboarding_screen.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/screens/main_screen.dart';
import 'package:jamu_saripah/admin_screen/admin_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider('6Lcw-5pAAAAAAH_Uxyz...'), 
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

// main.dart

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => OrderProvider()), // ✅ Tambahkan ini
      ChangeNotifierProvider(create: (_) => AuthUserProvider()), // ✅ Tambahkan ini
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jamu Saripah',
        routes: {
          '/login': (context) => const LoginScreen(),
        },
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        ),
        home: showOnboarding ? const OnboardingScreen() : const AuthWrapper(),
      ),
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
        // ⏳ Sedang mengecek status koneksi ke Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF8DA05E)),
            ),
          );
        }

        // ❌ User belum login, arahkan ke LoginScreen
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // ✅ User sudah login, ambil datanya untuk cek Role
        final String uid = snapshot.data!.uid;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, roleSnapshot) {
            // ⏳ Sedang mengambil data role dari Firestore
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF8DA05E)),
                ),
              );
            }

            // ✅ Cek apakah dokumen user ada dan ambil rolenya
            if (roleSnapshot.hasData && roleSnapshot.data!.exists) {
              final data = roleSnapshot.data!.data() as Map<String, dynamic>;
              final String role = data['role'] ?? 'user';

              if (role == 'admin') {
                return const AdminMainScreen();
              }
            }

            // Jika role bukan admin atau data tidak ditemukan, ke MainScreen (User)
            return const MainScreen();
          },
        );
      },
    );
  }
}