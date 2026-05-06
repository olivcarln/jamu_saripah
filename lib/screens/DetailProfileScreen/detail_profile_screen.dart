import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Tambahkan ini
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_avatar.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_button.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_textfield.dart';
import 'package:jamu_saripah/services/profile_services.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailProfileScreen extends StatefulWidget {
  const DetailProfileScreen({super.key});

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  final _service = ProfileService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _picker = ImagePicker();

  bool _isLoading = true;
  bool _isSaving = false;
  File? _imageFile;
  String? _photoUrl;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _initRealtime();
  }

  void _initRealtime() {
    final user = _service.currentUser;
    final uid = user?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      if (mounted) {
        setState(() {
          if (doc.exists) {
            final data = doc.data();
            _nameController.text = data?['name'] ?? user?.displayName ?? '';
            _emailController.text = data?['email'] ?? user?.email ?? '';
            _photoUrl = data?['photoUrl'];
            if (data?['createdAt'] != null) {
              _createdAt = (data!['createdAt'] as Timestamp).toDate();
            }
          } else {
            _nameController.text = user?.displayName ?? '';
            _emailController.text = user?.email ?? '';
          }
          _isLoading = false;
        });
      }
    });
  }

  String _formatDate(DateTime date) {
    const months = ["Januari","Februari","Maret","April","Mei","Juni","Juli","Agustus","September","Oktober","November","Desember"];
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) await Permission.camera.request();
    else await Permission.photos.request();

    final picked = await _picker.pickImage(source: source, imageQuality: 50);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Kamera"), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
          ListTile(leading: const Icon(Icons.photo_library), title: const Text("Galeri"), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
        ],
      ),
    );
  }

  // --- LOGIC PENYIMPANAN YANG SUDAH DISINKRONKAN ---
  Future<void> _handleSave() async {
    final user = _service.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      // 1. Upload foto ke Firebase Storage jika ada file baru dipilih
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        
        await ref.putFile(_imageFile!);
        _photoUrl = await ref.getDownloadURL();
      }

      // 2. Simpan semua data ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'photoUrl': _photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        // Jika data baru, tambahkan createdAt
        if (_createdAt == null) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() => _imageFile = null);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil disimpan ✨"), 
            backgroundColor: Color(0xFF7B8B5C), 
            behavior: SnackBarBehavior.floating
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal simpan profil"), 
            backgroundColor: Colors.red, 
            behavior: SnackBarBehavior.floating
          ),
        );
      }
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6E864C)), onPressed: () => Navigator.pop(context)),
        title: const Text('Akun Saya', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFDDE3D1), borderRadius: BorderRadius.circular(20)),
                      child: Text(_createdAt != null ? 'Member sejak: ${_formatDate(_createdAt!)}' : 'Member sejak: -', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 30),
                    // Menampilkan avatar dari file lokal atau URL Firestore
                    ProfileAvatar(imageFile: _imageFile, photoUrl: _photoUrl, onTap: _showPicker),
                    const SizedBox(height: 12),
                    const Text("Lengkapi data dirimu sekarang dan dapatkan\nvoucher menarik di hari spesialmu.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6E864C), fontSize: 14, height: 1.6, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 30),
                    ProfileTextField(controller: _nameController, hint: "Nama pengguna"),
                    const SizedBox(height: 14),
                    ProfileTextField(controller: _emailController, hint: "Email", enabled: false),
                    const SizedBox(height: 80),
                    ProfileButton(text: _isSaving ? "Menyimpan..." : "Simpan!", onPressed: _isSaving ? null : _handleSave),
                  ],
                ),
              ),
            ),
    );
  }
}