import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;

  // Fungsi untuk buat dokumen user pertama kali agar punya createdAt
  Future<void> createUserIfNotExists() async {
    final user = currentUser;
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
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

  // Fungsi upload foto ke Firebase Storage
  Future<String> uploadImage(File file) async {
    final uid = currentUser!.uid;
    final ref = _storage.ref().child('profile_pictures/$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Fungsi simpan perubahan profil ke Firestore
  Future<void> saveProfile({
    required String name,
    required String email,
    required String phone,
    String? photoUrl,
  }) async {
    final uid = currentUser!.uid;
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (photoUrl != null && photoUrl.isNotEmpty) {
      data['photoUrl'] = photoUrl;
    }

    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
}