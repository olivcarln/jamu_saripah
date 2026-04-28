import 'package:flutter/material.dart';

class EmptyOrderStateScreen extends StatelessWidget {
  const EmptyOrderStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ganti dengan Image.asset jika kamu sudah punya filenya
          Icon(Icons.inventory_2_outlined, size: 120, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            "Belum Ada Riwayat Pesanan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}