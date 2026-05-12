import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/providers/cart_provider.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';
import 'package:provider/provider.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Silakan login terlebih dahulu")),
      );
    }

    final userId = user.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// HEADER
          VoucherHeader(isVoucherActive: true, onPaydayTap: () {}),

          const Divider(height: 1),

          /// LIST VOUCHER
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('global_vouchers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Belum ada voucher tersedia"),
                  );
                }

                final now = DateTime.now();

                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data['isUsed'] == true) return false;
                  if ((data['quota'] ?? 0) <= 0) return false;

                  if (data['expiredAt'] != null) {
                    final expiredAt = (data['expiredAt'] as Timestamp).toDate();
                    final today = DateTime(now.year, now.month, now.day);
                    final expiryDate = DateTime(
                      expiredAt.year,
                      expiredAt.month,
                      expiredAt.day,
                    );

                    if (expiryDate.isBefore(today)) return false;
                  } else {
                    return false;
                  }
                  return true;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Text("Voucher sudah habis atau expired"),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final expiredAt = (data['expiredAt'] as Timestamp).toDate();

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('claimed_vouchers')
                          .doc(doc.id)
                          .snapshots(),
                      builder: (context, claimSnapshot) {
                        if (claimSnapshot.hasData && claimSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          // Menggunakan Wrap agar kartu tidak tertekan secara vertikal oleh list
                          child: VoucherCard(
                            title: data['code'] ?? 'PROMO',
                            subTitle: "Diskon ${data['discount']}%",
                            expiryDate: "${expiredAt.day}/${expiredAt.month}/${expiredAt.year}",
                            minTransaction: "Min: Rp ${data['minPurchase']}", // Diperpendek agar hemat space
                            quota: "Sisa: ${data['quota']}",
                            discountAmount: (data['discount'] ?? 0).toDouble() *
                                (data['minPurchase'] ?? 0).toDouble() /
                                100,
                            onClaim: () {
                              context.read<CartProvider>().applyVoucher(
                                    double.tryParse(data['discount']?.toString() ?? '0') ?? 0.0,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: const [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text("Voucher berhasil terpasang!"),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: const Color(0xFF6B7548),
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}