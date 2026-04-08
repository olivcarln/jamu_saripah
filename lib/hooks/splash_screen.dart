import 'dart:async';
import 'package:flutter/material.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  void startLoading() {
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      setState(() {
        progress += 0.02;
      });

      if (progress >= 1) {
        timer.cancel();
        // nanti bisa navigate ke halaman utama
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// GLITCH OVERLAY (optional)
          Positioned.fill(
            child: Container(
              color: Colors.green.withOpacity(0.05),
            ),
          ),

          /// CONTENT CENTER
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                /// ✅ SVG LOGO (PINDAH KE SINI)
                Image.asset(
                  "assets/logo_jamusaripah.png",
                  width: 200,
                ),

                const SizedBox(height: 25),

      

                const SizedBox(height: 30),

                /// LOADING BAR (COKELAT)
                Container(
                  width: 200,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 200 * progress,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5E3C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

            
              ],
            ),
          ),
        ],
      ),
    );
  }
}