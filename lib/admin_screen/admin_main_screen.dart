import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Jamu Saripah", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF7E8959),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login'); // Pastikan route login sesuai
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Bisnis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Row untuk Kotak Statistik
            Row(
              children: [
                _buildStatCard("Produk", "12", Colors.blue),
                const SizedBox(width: 10),
                _buildStatCard("Pesanan", "5", Colors.orange),
              ],
            ),
            
            const SizedBox(height: 24),
            const Text(
              "Daftar Inventaris Jamu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Dummy List Produk (Nanti ini bisa dihubungkan ke StreamBuilder Firestore)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                List<String> jamuNames = ["Kunyit Asam", "Beras Kencur", "Temulawak"];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF7E8959),
                      child: Icon(Icons.local_drink, color: Colors.white),
                    ),
                    title: Text(jamuNames[index]),
                    subtitle: Text("Stok: ${10 + index} | Rp 15.000"),
                    trailing: const Icon(Icons.edit, color: Colors.grey),
                    onTap: () {
                      // Logika Edit Produk
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7E8959),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Logika Tambah Produk Baru
          _showSnackBar(context, "Fitur Tambah Produk Segera Hadir!");
        },
      ),
    );
  }

  // Widget Helper untuk Kotak Statistik
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}