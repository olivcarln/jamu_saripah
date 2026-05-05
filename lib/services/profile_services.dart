import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  // 🔥 GET USER DATA
  Future<Map<String, dynamic>?> getUserData() async {
    final user = currentUser;
    if (user == null) return null;

    final doc =
        await _firestore.collection('users').doc(user.uid).get();

    return doc.data();
  }

  // 🔥 UPLOAD IMAGE (NON NULL)
  Future<String> uploadImage(File file) async {
    final user = currentUser;
    if (user == null) throw Exception("User not logged in");

    final ref = _storage
        .ref()
        .child('profile_pictures/${user.uid}.jpg');

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    // update ke auth juga (optional tapi bagus)
    await user.updatePhotoURL(url);

    return url;
  }

  // 🔥 SAVE PROFILE (ANTI NULL OVERWRITE)
  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    String? photoUrl,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await user.updateDisplayName(name);

    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // ✅ hanya update kalau ada
    if (photoUrl != null && photoUrl.isNotEmpty) {
      data['photoUrl'] = photoUrl;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(data, SetOptions(merge: true));
  }

  // 🔥 CREATE USER
  Future<void> createUserIfNotExists() async {
    final user = currentUser;
    if (user == null) return;

    final docRef =
        _firestore.collection('users').doc(user.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': '',
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}