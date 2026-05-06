import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna tema konsisten dengan Jamu Saripah
    final Color primaryColor = const Color(0xFF8DA05E); 
    final Color backgroundColor = const Color(0xFFF9FAf7); // Abu-abu kehijauan sangat muda

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Intro
            Text(
              "Keamanan Data Anda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kami berkomitmen melindungi setiap informasi yang Anda percayakan kepada Jamu Saripah.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 25),

            // Daftar Kebijakan dengan gaya Clean Card
            _buildCleanCard(
              icon: Icons.security_outlined,
              title: "Perlindungan Data",
              desc: "Semua data pribadi Anda dienkripsi menggunakan standar keamanan Firebase tingkat tinggi.",
              color: primaryColor,
            ),
            _buildCleanCard(
              icon: Icons.person_search_outlined,
              title: "Pengumpulan Informasi",
              desc: "Kami hanya mengambil data nama, email, dan alamat untuk keperluan pengiriman dan akun.",
              color: primaryColor,
            ),
            _buildCleanCard(
              icon: Icons.visibility_off_outlined,
              title: "Kerahasiaan",
              desc: "Jamu Saripah tidak akan pernah menjual atau membagikan data Anda kepada pihak iklan manapun.",
              color: primaryColor,
            ),
            _buildCleanCard(
              icon: Icons.history_outlined,
              title: "Pembaruan Kebijakan",
              desc: "Kami dapat memperbarui kebijakan ini secara berkala untuk meningkatkan layanan keamanan kami.",
              color: primaryColor,
            ),

            const SizedBox(height: 40),
            
            // Footer Contact
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Icon(Icons.mail_outline, color: primaryColor),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Butuh bantuan?", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Hubungi tim privasi kami", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Card Clean
  Widget _buildCleanCard({
    required IconData icon, 
    required String title, 
    required String desc, 
    required Color color
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}