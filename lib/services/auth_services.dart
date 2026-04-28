import 'package:firebase_auth/firebase_auth.dart';
import 'package:jamu_saripah/services/profile_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> register({
    required String email,
    required String password,
    String? username,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // ✅ SET DISPLAY NAME DULU
    if (username != null && username.isNotEmpty) {
      await userCredential.user?.updateDisplayName(username);
    }

    // 🔥 BARU BUAT DATA DI FIRESTORE
    await ProfileService().createUserIfNotExists();

    return userCredential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 🔥 PENTING: handle user lama / belum ada data
    await ProfileService().createUserIfNotExists();

    return userCredential;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}