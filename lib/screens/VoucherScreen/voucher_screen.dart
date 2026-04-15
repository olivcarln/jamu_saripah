import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VoucherScreen/component/voucher_card.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita pakai Column saja agar bisa langsung ditempel ke body Scaffold utama
    return Column(
      children: [
        _buildAppBarSimulated(), // AppBar buatan sendiri karena ini di dalam body
        _buildSearchBox(),
        _buildTabHeader(),
        const Divider(height: 1),
        _buildOrderSummary(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) => const VoucherCard(),
          ),
        ),
      ],
    );
  }

  // Pengganti AppBar jika tidak ingin pakai AppBar bawaan Scaffold
  Widget _buildAppBarSimulated() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 10),
      alignment: Alignment.center,
      child: const Text(
        'Vouchers',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Dapat kode promo? masukkan disini',
          prefixIcon: const Icon(Icons.confirmation_number_outlined, color: Colors.green),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildTabHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          Text('Vouchers', style: TextStyle(color: Color(0xFF6D4C41), fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(width: 40),
          Text('Rewards', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Order Voucher', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('5 Vouchers', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}