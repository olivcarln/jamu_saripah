import 'package:flutter/material.dart';

class ShoppingBagScreen extends StatelessWidget {
  final bool isSelected;
  final int harga;
  final ValueChanged<bool> onChanged;

  const ShoppingBagScreen({
    super.key,
    required this.isSelected,
    required this.harga,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(thickness: 8, color: Color(0xFFF1F1F1)),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // PERBAIKAN: Background dibuat hijau sangat muda (opacity 10-20%)
              color: const Color(0xFF7E8959).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFF7E8959), // Icon hijau tua
            ),
          ),
          title: const Text(
            'Perlu Tas Belanja?',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Rp $harga', style: const TextStyle(fontSize: 12)),
          trailing: Switch(
            value: isSelected,
            onChanged: onChanged,
            activeColor: Colors.white, // Warna buletan pas aktif
            activeTrackColor: const Color(0xFF7E8959), // Hijau khas aplikasi lu
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
