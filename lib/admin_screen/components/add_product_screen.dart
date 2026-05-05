import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Fungsi ambil gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() {
        _imageFile = File(selected.path);
      });
    }
  }

  // Fungsi utama: Upload foto & Simpan data ke Firestore
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih foto produk terlebih dahulu!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload Foto ke Firebase Storage
      String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.png';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(_imageFile!);
      
      // 2. Ambil URL foto yang sudah diupload
      String imageUrl = await snapshot.ref.getDownloadURL();

      // 3. Simpan data ke Cloud Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'price': int.parse(_priceController.text.trim()),
        'discount': _discountController.text.isEmpty 
            ? 0 
            : int.parse(_discountController.text.trim()),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk Jamu", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7E8959),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Foto Produk", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  // Kotak Upload Foto
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400),
                        image: _imageFile != null
                            ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _imageFile == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Klik untuk upload foto", style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildLabel("Nama Jamu"),
                  _buildTextField(_nameController, "Contoh: Kunyit Asam Segar", Icons.medication_liquid),
                  const SizedBox(height: 16),

                  _buildLabel("Harga (Rp)"),
                  _buildTextField(_priceController, "Contoh: 15000", Icons.money, isNumber: true),
                  const SizedBox(height: 16),

                  _buildLabel("Diskon (%)"),
                  _buildTextField(_discountController, "0", Icons.percent, isNumber: true, isRequired: false),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7E8959),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _isLoading ? null : _saveProduct,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Simpan Produk", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Overlay loading agar layar tidak bisa diklik saat proses
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator(color: Color(0xFF7E8959))),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF7E8959)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "Bidang ini tidak boleh kosong";
        }
        return null;
      },
    );
  }
}