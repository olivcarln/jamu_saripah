import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  final bool isAllSelected;
  final VoidCallback onToggleAll;
  final VoidCallback onDeleteAll;
  final bool canDelete; // Cek ada yang dipilih atau nggak

  const CartHeader({
    super.key,
    required this.isAllSelected,
    required this.onToggleAll,
    required this.onDeleteAll,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SISI KIRI: Pilih Semua (Selalu muncul)
          GestureDetector(
            onTap: onToggleAll,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(
                  isAllSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: const Color(0xFF7E8959),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Pilih Semua", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          
          // SISI KANAN: Tombol Hapus (Cuma muncul kalo ada yang dipilih)
          if (canDelete) // LOGIKA MAGIC-NYA DI SINI
            GestureDetector(
              onTap: onDeleteAll,
              behavior: HitTestBehavior.opaque,
              child: const Row(
                children: [
                  Text(
                    "Hapus", 
                    style: TextStyle(
                      color: Colors.red, 
                      fontSize: 13, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ],
              ),
            )
          else
            const SizedBox(width: 20), // Placeholder kosong biar Row nggak berantakan
        ],
      ),
    );
  }
}