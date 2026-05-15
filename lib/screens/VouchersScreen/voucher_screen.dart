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
      return const Scaffold(
        body: Center(
          child: Text(
            "Silakan login terlebih dahulu",
          ),
        ),
      );
    }

    final userId = user.uid;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          VoucherHeader(
            isVoucherActive: true,
            onPaydayTap: () {},
          ),

          const Divider(height: 1),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('global_vouchers')
                  .snapshots(),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada voucher tersedia",
                    ),
                  );
                }

                final now = DateTime.now();

                final filteredDocs =
                    snapshot.data!.docs.where((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;

                  /// QUOTA HABIS
                  if ((data['quota'] ?? 0) <= 0) {
                    return false;
                  }

                  /// TIDAK ADA EXPIRED
                  if (data['expiredAt'] == null) {
                    return false;
                  }

                  try {
                    final expiredAt =
                        (data['expiredAt'] as Timestamp)
                            .toDate();

                    final today = DateTime(
                      now.year,
                      now.month,
                      now.day,
                    );

                    final expiredDateOnly = DateTime(
                      expiredAt.year,
                      expiredAt.month,
                      expiredAt.day,
                    );

                    /// EXPIRED
                    if (expiredDateOnly
                        .isBefore(today)) {
                      return false;
                    }
                  } catch (e) {
                    return false;
                  }

                  return true;
                }).toList();

                if (filteredDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada voucher aktif",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),

                  itemCount: filteredDocs.length,

                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];

                    final data =
                        doc.data() as Map<String, dynamic>;

                    DateTime expiredDate =
                        DateTime.now();

                    if (data['expiredAt'] != null) {
                      expiredDate =
                          (data['expiredAt']
                                  as Timestamp)
                              .toDate();
                    }

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(userId)
                          .collection(
                              'claimed_vouchers')
                          .doc(doc.id)
                          .snapshots(),

                      builder:
                          (context, claimSnapshot) {

                        /// SUDAH CLAIM / USED
                        bool isAlreadyUsed =
                            claimSnapshot.hasData &&
                                claimSnapshot
                                    .data!.exists;

                        /// NOMINAL DISKON
                        int nominalDiskon =
                            ((data['discount'] ?? 0)
                                        .toDouble() *
                                    (data['minPurchase'] ??
                                            0)
                                        .toDouble() /
                                    100)
                                .toInt();

                        return Opacity(
                          opacity:
                              isAlreadyUsed
                                  ? 0.5
                                  : 1,

                          child: Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),

                            child: VoucherCard(
                              title:
                                  data['code'] ??
                                      'PROMO',

                              subTitle:
                                  isAlreadyUsed
                                      ? "Voucher sudah digunakan"
                                      : "Diskon ${data['discount']}%",

                              expiryDate:
                                  "${expiredDate.day}/${expiredDate.month}/${expiredDate.year}",

                              minTransaction:
                                  "Rp ${data['minPurchase'] ?? 0}",

                              quota:
                                  isAlreadyUsed
                                      ? "Voucher Expired"
                                      : "Sisa ${data['quota'] ?? 0}",

                              discountAmount:
                                  nominalDiskon
                                      .toDouble(),

                              /// BUTTON
                              buttonText:
                                  isAlreadyUsed
                                      ? "Expired"
                                      : "Gunakan",

                              onClaim:
                                  isAlreadyUsed
                                      ? null
                                      : () async {

                                          /// APPLY KE CART
                                          context
                                              .read<
                                                  CartProvider>()
                                              .applyVoucher(
                                                nominalDiskon
                                                    .toDouble(),
                                              );

                                          /// SIMPAN KE USER
                                          await FirebaseFirestore
                                              .instance
                                              .collection(
                                                  'users')
                                              .doc(
                                                  userId)
                                              .collection(
                                                  'claimed_vouchers')
                                              .doc(doc.id)
                                              .set({
                                            'voucherId':
                                                doc.id,

                                            'voucherCode':
                                                data['code'],

                                            'discount':
                                                data['discount'],

                                            'usedAt':
                                                FieldValue
                                                    .serverTimestamp(),

                                            'status':
                                                'used',
                                          });

                                          /// KURANGI QUOTA
                                          await FirebaseFirestore
                                              .instance
                                              .collection(
                                                  'global_vouchers')
                                              .doc(doc.id)
                                              .update({
                                            'quota':
                                                FieldValue
                                                    .increment(
                                              -1,
                                            ),
                                          });

                                          if (!context
                                              .mounted) {
                                            return;
                                          }

                                          /// SNACKBAR
                                          ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior
                                                      .floating,

                                              backgroundColor:
                                                  const Color(
                                                      0xFF6B7548),

                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16),
                                              ),

                                              content:
                                                  Text(
                                                "Voucher ${data['code']} berhasil digunakan",
                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.white,

                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                            ),
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