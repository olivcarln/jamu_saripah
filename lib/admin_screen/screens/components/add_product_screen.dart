import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? data;

  const AddProductScreen({super.key, this.id, this.data});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _discountController = TextEditingController();
  final _descController = TextEditingController();

  final _picker = ImagePicker();

  File? _imageFile;
  String? _imageUrl;

  bool _isLoading = false;

  bool get isEdit => widget.id != null;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      _nameController.text = widget.data!['name'] ?? '';

      _priceController.text = (widget.data!['price'] ?? '').toString();

      _stockController.text = (widget.data!['stock'] ?? '').toString();

      _discountController.text = (widget.data!['discount'] ?? '').toString();

      _descController.text = widget.data!['description'] ?? '';

      _imageUrl = widget.data!['imageUrl'];
    }
  }

  /// PICK IMAGE
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 800,
    );

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  /// CONVERT IMAGE TO BASE64
  Future<String?> _uploadImage() async {
    if (_imageFile == null) return _imageUrl;

    final bytes = await _imageFile!.readAsBytes();

    return base64Encode(bytes);
  }

  /// SAVE PRODUCT
  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _discountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi semua field dulu ya")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final collection = FirebaseFirestore.instance.collection('products');

      final docRef = isEdit ? collection.doc(widget.id) : collection.doc();

      final imageBase64 = await _uploadImage();

      await docRef.set({
        'name': _nameController.text,
        'price': int.tryParse(_priceController.text) ?? 0,
        'stock': int.tryParse(_stockController.text) ?? 0,
        'discount': int.tryParse(_discountController.text) ?? 0,
        'description': _descController.text,
        'imageUrl': imageBase64,
        'updatedAt': FieldValue.serverTimestamp(),

        if (!isEdit) 'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? "Produk berhasil diupdate"
                  : "Produk berhasil ditambahkan",
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal simpan produk\n$e")));
    }

    setState(() => _isLoading = false);
  }

  /// IMAGE PREVIEW
  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            base64Decode(_imageUrl!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      } catch (e) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.camera_alt, size: 40, color: Colors.grey),

        SizedBox(height: 8),

        Text("Tambah Foto", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// INPUT FIELD
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,

        filled: true,
        fillColor: const Color(0xFFF5F6F2),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _descController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),

      appBar: AppBar(
        title: Text(isEdit ? "Edit Produk" : "Tambah Produk"),

        backgroundColor: Colors.transparent,

        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// IMAGE
            GestureDetector(
              onTap: _pickImage,

              child: Container(
                height: 170,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: const Color(0xFFE5EAD9),

                  borderRadius: BorderRadius.circular(18),
                ),

                child: Center(child: _buildImagePreview()),
              ),
            ),

            const SizedBox(height: 25),

            /// FORM
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),

              child: Column(
                children: [
                  _inputField(
                    controller: _nameController,
                    label: "Nama Produk",
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: _priceController,
                    label: "Harga",
                    type: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: _discountController,
                    label: "Diskon (%)",
                    type: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: _stockController,
                    label: "Stok",
                    type: TextInputType.number,
                  ),

                  const SizedBox(height: 15),

                  _inputField(
                    controller: _descController,
                    label: "Deskripsi",
                    maxLines: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B8B5C),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: Text(
                  _isLoading
                      ? "Menyimpan..."
                      : (isEdit ? "Update Produk" : "Tambah Produk"),

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
