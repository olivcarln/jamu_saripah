import 'package:flutter/material.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});

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
          "Pilih Lokasi Pengiriman",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              autofocus: true, // Langsung fokus saat pindah halaman
              decoration: InputDecoration(
                hintText: "Cari Lokasi",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          // HASIL PENCARIAN (Box Washington DC)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, "Jakarta Selatan"); 
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6E8B4F).withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jakarta Selatan",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Jl. Kemang Raya No.10, RT.5/RW.1, Bangka, Kec. Mampang Prapatan",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}