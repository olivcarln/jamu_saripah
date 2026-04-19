import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jamu_saripah/screens/PickupScreen/pickup_screen.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7E8959),
                ),
              ),
            );
          }
          if (snapshot.hasData) { 
            return const PickupScreen(); 
          }
          return const PickupScreen();
        }
       
      ),
    );
  }
}