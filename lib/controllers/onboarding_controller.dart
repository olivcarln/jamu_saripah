import 'package:flutter/material.dart';

class OnboardingController {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "title": "Delivery",
      "desc":
          "Nikmati jamu segar langsung diantar ke rumahmu dengan cepat dan aman",
      "image": "assets/delivery.svg"
    },
    {
      "title": "Preorder",
      "desc":
          "Pesan jamu lebih awal dan dapatkan tepat waktu sesuai kebutuhanmu.",
      "image": "assets/preorder.svg"
    },
    {
      "title": "Start today",
      "desc":
          "Mulai hidup sehat dari hari ini dengan jamu alami pilihan terbaik.",
      "image": "assets/start.svg"
    },
  ];
}