import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_avatar.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_button.dart';
import 'package:jamu_saripah/screens/DetailProfileScreen/components/profile_textfield.dart';
import 'package:jamu_saripah/screens/hooks/onBoarding/onboarding_screen.dart';
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

  bool _isLoading = true;
  bool _isSaving = false;

  File? _imageFile;
  String? _photoUrl;

  DateTime? _createdAt;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initRealtime();
  }

  // 🔥 REALTIME LISTENER
  void _initRealtime() {
    final uid = _service.currentUser?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((doc) {
      final data = doc.data();
      final user = _service.currentUser;

      if (data != null) {
        _nameController.text =
            data['name'] ?? user?.displayName ?? '';
        _emailController.text =
            data['email'] ?? user?.email ?? '';
        _photoUrl = data['photoUrl'] ?? user?.photoURL;

        if (data['createdAt'] != null) {
          _createdAt = (data['createdAt'] as Timestamp).toDate();
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      "Januari","Februari","Maret","April",
      "Mei","Juni","Juli","Agustus",
      "September","Oktober","November","Desember"
    ];

    return "${date.day.toString().padLeft(2, '0')} "
        "${months[date.month - 1]} "
        "${date.year}";
  }

  Future<void> _pickImage(ImageSource source) async {
    final status = source == ImageSource.camera
        ? await Permission.camera.request()
        : await Permission.photos.request();

    if (!status.isGranted) return;

    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            title: const Text("Kamera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            title: const Text("Galeri"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      if (_imageFile != null) {
        final url = await _service.uploadImage(_imageFile!);
        _photoUrl = url;
      }

      await _service.saveProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: "",
        photoUrl: _photoUrl,
      );

      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      print("ERROR SAVE: $e");
    }

    setState(() => _isSaving = false);
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6E864C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Akun Saya',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE3D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _createdAt != null
                            ? 'Member sejak: ${_formatDate(_createdAt!)}'
                            : 'Member sejak: -',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ProfileAvatar(
                      imageFile: _imageFile,
                      photoUrl: _photoUrl,
                      onTap: _showPicker,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Lengkapi data dirimu sekarang dan dapatkan\nvoucher menarik di hari spesialmu.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6E864C),
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ProfileTextField(
                      controller: _nameController,
                      hint: "Nama pengguna",
                    ),

                    const SizedBox(height: 14),

                    ProfileTextField(
                      controller: _emailController,
                      hint: "Email",
                      enabled: false,
                    ),

                    const SizedBox(height: 180),

                    ProfileButton(
                      text: "Simpan!",
                      onPressed: _handleSave,
                    ),

                    const SizedBox(height: 16),

                    TextButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFD32F2F),
                      ),
                      label: const Text(
                        "HAPUS AKUN",
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}