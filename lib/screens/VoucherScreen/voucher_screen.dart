import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VoucherScreen/component/voucher_card.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildAppBarSimulated(), 
          _buildSearchBox(),
          _buildTabHeader(),
          Divider(height: 1),
          _buildOrderSummary(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) => VoucherCard(),
            ),
          ),
        ],
      ),
    );
  }

  // Pengganti AppBar jika tidak ingin pakai AppBar bawaan Scaffold
  Widget _buildAppBarSimulated() {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 10),
      alignment: Alignment.center,
      child: Text(
        'Vouchers',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
      ),
    );
  }

 Widget _buildSearchBox() {
  return Padding(
    padding: EdgeInsets.all(20),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Dapat kode promo? masukkan disini',
        hintStyle: TextStyle(
          color: Color(0xFF7B8D5E)
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 13),
          child: Icon(Icons.confirmation_number_outlined, color: Color(0xFF7B8D5E)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0),

        // ketika border tidak fokus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xFF7B8D5E),
            width: 2,
          ),
        ),
     // ketika border fokus
          focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Color(0xFF7B8D5E), // warna pas focus
          width: 2.5, // lebih tebal
        ),
      ),
      ),
    ),
  );
}

  Widget _buildTabHeader() {
    return Padding(
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
    return Padding(
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