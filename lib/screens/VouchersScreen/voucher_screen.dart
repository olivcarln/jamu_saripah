import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/provider/cart_provider.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';
import 'package:provider/provider.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Silakan login terlebih dahulu")));
    }
    final userId = user.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          VoucherHeader(isVoucherActive: true, onPaydayTap: () {}),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('global_vouchers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Belum ada voucher tersedia"));
                }

                final now = DateTime.now();
                
                // Filter voucher yang valid
                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  
                  // 1. Cek Quota & Status Pakai
                  if (data['isUsed'] == true || (data['quota'] ?? 0) <= 0) return false;
                  
                  // 2. Cek Tanggal (Anti Error Null)
                  if (data['expiredAt'] == null) return false; // Abaikan jika tanggal kosong
                  
                  try {
                    final expiredAt = (data['expiredAt'] as Timestamp).toDate();
                    final today = DateTime(now.year, now.month, now.day);
                    if (DateTime(expiredAt.year, expiredAt.month, expiredAt.day).isBefore(today)) return false;
                  } catch (e) {
                    return false; // Jika format salah, abaikan vouchernya
                  }
                  
                  return true;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    
                    // Ambil tanggal dengan aman
                    DateTime expiredDate = DateTime.now();
                    if (data['expiredAt'] != null) {
                      expiredDate = (data['expiredAt'] as Timestamp).toDate();
                    }

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('claimed_vouchers')
                          .doc(doc.id)
                          .snapshots(),
                      builder: (context, claimSnapshot) {
                        // CEK APAKAH VOUCHER SUDAH TERPAKAI
                        bool isAlreadyUsed = claimSnapshot.hasData && claimSnapshot.data!.exists;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: VoucherCard(
                            title: data['code'] ?? 'PROMO',
                            subTitle: "Diskon ${data['discount']}%",
                            expiryDate: "${expiredDate.day}/${expiredDate.month}/${expiredDate.year}",
                            minTransaction: "Min: Rp ${data['minPurchase'] ?? 0}",
                            quota: "Sisa: ${data['quota'] ?? 0}",
                            discountAmount: (data['discount'] ?? 0).toDouble() * (data['minPurchase'] ?? 0).toDouble() / 100,
                            
                            // Logika Tombol
                            buttonText: isAlreadyUsed ? "Telah Terpakai" : "Gunakan",
                            onClaim: isAlreadyUsed ? null : () {
                              int nominalDiskon = ((data['discount'] ?? 0).toDouble() * (data['minPurchase'] ?? 0).toDouble() / 100).toInt();

                              Navigator.pop(context, {
                                'code': data['code'] ?? 'PROMO',
                                'discount': nominalDiskon,
                              });

                              context.read<CartProvider>().applyVoucher(
                                    double.tryParse(data['discount']?.toString() ?? '0') ?? 0.0,
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