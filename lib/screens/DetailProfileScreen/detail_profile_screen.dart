import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔥 Tambahan
import 'package:firebase_storage/firebase_storage.dart';
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

            _nameController.text =
                data?['name'] ?? user?.displayName ?? '';
            _emailController.text =
                data?['email'] ?? user?.email ?? '';
            _photoUrl = data?['photoBase64'];

            if (data?['createdAt'] != null) {
              _createdAt =
                  (data!['createdAt'] as Timestamp).toDate();
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
    const months = [
      "Januari","Februari","Maret","April","Mei","Juni",
      "Juli","Agustus","September","Oktober","November","Desember"
    ];

    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    } else {
      await Permission.photos.request();
    }

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );

    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Kamera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
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

  /// 🔥 SAVE PROFILE

Future<void> _handleSave() async {
  final user = _service.currentUser;
  if (user == null) return;

  setState(() => _isSaving = true);

  try {
    String? base64Image;

    // kalau pilih image baru
    if (_imageFile != null) {
      List<int> imageBytes =
          await _imageFile!.readAsBytes();

      base64Image = base64Encode(imageBytes);
    }

    Map<String, dynamic> data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'updatedAt': FieldValue.serverTimestamp(),

      if (_createdAt == null)
        'createdAt': FieldValue.serverTimestamp(),
    };

    // hanya update image kalau ada image baru
    if (base64Image != null) {
      data['photoBase64'] = base64Image;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
          data,
          SetOptions(merge: true),
        );

    // update state local supaya langsung tampil
    if (base64Image != null) {
      setState(() {
        _photoUrl = base64Image;
      });
    }

    setState(() {
      _imageFile = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profil berhasil disimpan ✨",
          ),
          backgroundColor: Color(0xFF7B8B5C),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Gagal simpan profil"),
        backgroundColor: Colors.red,
      ),
    );
  }

  setState(() => _isSaving = false);
}

  /// 🔥 LOGOUT
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal logout"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 🔥 CONFIRM LOGOUT
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Kamu yakin mau logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
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
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFF6E864C)),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDE3D1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _createdAt != null
                            ? 'Member sejak: ${_formatDate(_createdAt!)}'
                            : 'Member sejak: -',
                      ),
                    ),

                    const SizedBox(height: 30),

                    ProfileAvatar(
                      base64Image: _photoUrl,
                      imageFile: _imageFile,
                      onTap: _showPicker,
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

                    const SizedBox(height: 60),

                    ProfileButton(
                      text: _isSaving ? "Menyimpan..." : "Simpan!",
                      onPressed:
                          _isSaving ? null : _handleSave,
                    ),

                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: _confirmLogout,
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
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