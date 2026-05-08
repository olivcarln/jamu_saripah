import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white, // Background putih untuk kondisi belum login
        body: Center(child: Text("Silakan login terlebih dahulu")),
      );
    }

    final userId = user.uid;

    // Gunakan Scaffold agar bisa mengatur backgroundColor
    return Scaffold(
      backgroundColor: Colors.white, // <--- SET WARNA PUTIH DI SINI
      body: Column(
        children: [
          /// HEADER
          VoucherHeader(
            isVoucherActive: true,
            onPaydayTap: () {},
          ),

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
                      child: Text("Belum ada voucher tersedia di database"));
                }

                final now = DateTime.now();

                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data['isUsed'] == true) return false;
                  if ((data['quota'] ?? 0) <= 0) return false;

                  if (data['expiredAt'] != null) {
                    final expiredAt = (data['expiredAt'] as Timestamp).toDate();
                    final today = DateTime(now.year, now.month, now.day);
                    final expiryDate =
                        DateTime(expiredAt.year, expiredAt.month, expiredAt.day);

                    if (expiryDate.isBefore(today)) return false;
                  } else {
                    return false;
                  }
                  return true;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("Voucher sudah habis atau expired"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
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

                        return VoucherCard(
                          title: data['code'] ?? 'PROMO',
                          subTitle: "Diskon ${data['discount']}%",
                          expiryDate:
                              "${expiredAt.day}/${expiredAt.month}/${expiredAt.year}",
                          minTransaction: "Rp ${data['minPurchase']}",
                          quota: "Sisa Kuota: ${data['quota']}",
                          onClaim: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text("Voucher berhasil terpasang!"),
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