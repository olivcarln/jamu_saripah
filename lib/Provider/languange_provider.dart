import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // Default ke Bahasa Indonesia ('id')
  Locale _currentLocale = const Locale('id');

  Locale get currentLocale => _currentLocale;

  // Fungsi untuk ganti bahasa
  void setLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners(); // Ini yang membuat semua widget refresh otomatis
  }
}