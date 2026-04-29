import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/screens/AccountScreen/components/location_selection_screen.dart';

class AddingAddress extends StatefulWidget {
  const AddingAddress({super.key});

  @override
  State<AddingAddress> createState() => _AddingAddressState();
}

class _AddingAddressState extends State<AddingAddress> {
  // Controller untuk mengambil data dari inputan
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _namaAlamatController = TextEditingController();
  final TextEditingController _detailAlamatController = TextEditingController();
  final TextEditingController _namaPenerimaController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  bool _isLoading = false;

  // Fungsi Logic Simpan ke Firestore
  Future<void> _saveAddress() async {
    // Validasi sederhana
    if (_namaAlamatController.text.isEmpty ||
        _namaPenerimaController.text.isEmpty ||
        _noTelpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon isi semua data yang wajib")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .add({
              'addressName': _namaAlamatController.text,
              'addressDetail': _detailAlamatController.text,
              'receiverName': _namaPenerimaController.text,
              'phoneNumber': _noTelpController.text,
              'locationName': "Washington DC", // Bisa dibuat dinamis nanti
              'createdAt': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Alamat berhasil disimpan!")),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6E8B4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Alamat Tersimpan",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6E8B4F)),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SEARCH BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _searchController,
                      readOnly:
                          true, // Membuat TextField tidak bisa diketik langsung di sini
                      onTap: () {
                        // PINDAH KE SCREEN PILIH LOKASI
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LocationSelectionScreen(),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Cari Lokasi",
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFF6E8B4F),
                          ), // Pakai warna Olive kamu
                        ),
                      ),
                    ),
                  ),
                  // MAP PLACEHOLDER
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://i.stack.imgur.com/HILmr.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),

                  // ALAMAT TERDETEKSI
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryOlive.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Washington DC",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Divider(thickness: 1),
                          Text(
                            "jl. Lapangan bola No.8 RT.7/RW.1, KB.semangka, Kec.Kb.semangka, Kota Depok, Derah Khusus ibukota Jakarta 1111530, Indonesia",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FORM INPUT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Detail Alamat",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),

                        _buildLabel("Nama Alamat"),
                        _buildTextField(
                          _namaAlamatController,
                          "Contoh: Rumah, Kantor",
                        ),

                        _buildLabel("Detail Alamat (opsional)"),
                        _buildTextField(
                          _detailAlamatController,
                          "Contoh: No. Rumah, Blok, dll",
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "Detail Penerima",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),

                        _buildLabel("Nama Penerima"),
                        _buildTextField(
                          _namaPenerimaController,
                          "Nama Penerima",
                        ),

                        _buildLabel("No.Telp"),
                        _buildTextField(
                          _noTelpController,
                          "Contoh: +62xxxxxxxxxx",
                          isPhone: true,
                        ),
                      ],
                    ),
                  ),

                  // BUTTON SIMPAN
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF6E8B4F,
                          ), // Hijau Jamu Saripah
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Simpan!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
