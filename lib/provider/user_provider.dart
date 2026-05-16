import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _name = "User";
  final _phone = "";

  String get name => _name;
  String get phone => _phone;


  // Load dari storage
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? "User";
    notifyListeners();
  }

  // Update username
  Future<void> updateName(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);

    _name = newName;
    notifyListeners(); 
  }
}