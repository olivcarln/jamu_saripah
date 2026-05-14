import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthUserProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}