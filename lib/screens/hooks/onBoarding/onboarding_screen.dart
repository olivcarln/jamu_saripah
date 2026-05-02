import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jamu_saripah/hooks/auth/login_screen.dart';
import 'package:jamu_saripah/hooks/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // WAJIB ADA
import 'package:jamu_saripah/controllers/onboarding_controller.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingController controller = OnboardingController();

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoSlide();
  }

  void startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) { // Ubah ke 3 detik biar user sempat baca
      if (!mounted) return;
      if (currentIndex < controller.data.length - 1) {
        currentIndex++;
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  // FUNGSI INI UNTUK PINDAH DAN SIMPAN STATUS
  void _finishOnboarding(Widget targetScreen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false); // Supaya gak muncul lagi

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.data.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  _timer?.cancel();
                  startAutoSlide();
                },
                itemBuilder: (context, index) {
                  return buildPage(controller.data[index]);
                },
              ),
            ),

            // DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currentIndex == index ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? const Color(0xFF7A7A3C)
                        : const Color(0xFFB77B5C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BUTTON AREA
            if (currentIndex == controller.data.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A7A3C),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => _finishOnboarding(const RegisterScreen()), // PINDAH KE DAFTAR
                      child: const Text(
                        "Daftar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        GestureDetector(
                          onTap: () => _finishOnboarding(const LoginScreen()), // PINDAH KE LOGIN
                          child: const Text(
                            "Masuk disini",
                            style: TextStyle(
                              color: Color(0xFF7A7A3C),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildPage(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(item["image"]!, height: 220),
          const SizedBox(height: 30),
          Text(
            item["title"]!,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            item["desc"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}