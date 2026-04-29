import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';

// TODO: Tambahkan logika untuk menampilkan daftar voucher yang dimiliki pengguna, 
// TODO: tampilkan image ketika tidak ada voucher, dan tambahkan fitur untuk menukarkan kode voucher jika ada input kode voucher


class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER (Reusable)
        VoucherHeader(
          isVoucherActive: true,
          onPaydayTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoucherHeader(),
              ),
            );
          },
        ),

        Divider(height: 1),

        // LIST VOUCHER (Reusable)
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => VoucherCard(),
          ),
        ),
      ],
    );
  }
}