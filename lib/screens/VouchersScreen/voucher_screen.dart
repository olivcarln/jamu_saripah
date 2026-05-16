import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';

class VoucherScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedVoucher;

  /// KIRIM SUBTOTAL DARI CHECKOUT
  final int subtotal;

  /// MULTIPLE VOUCHER
  final List<Map<String, dynamic>> selectedVouchers;

  const VoucherScreen({
    super.key,
    this.selectedVoucher,
    required this.subtotal,
    this.selectedVouchers = const [],
  });

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String? selectedVoucherId;

  /// MULTIPLE STACKING
  List<Map<String, dynamic>> selectedVoucherList = [];

  @override
  void initState() {
    super.initState();

    selectedVoucherId = widget.selectedVoucher?['id'];

    selectedVoucherList = [...widget.selectedVouchers];
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  bool isVoucherSelected(String id) {
    return selectedVoucherList.any(
      (voucher) => voucher['id'] == id,
    );
  }

  void toggleVoucher(
    Map<String, dynamic> voucher,
  ) {
    final alreadySelected = isVoucherSelected(
      voucher['id'],
    );

    setState(() {
      if (alreadySelected) {
        selectedVoucherList.removeWhere(
          (item) => item['id'] == voucher['id'],
        );
      } else {
        selectedVoucherList.add(voucher);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.85,

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),

        child: const Center(
          child: Text(
            "Silakan login terlebih dahulu",
          ),
        ),
      );
    }

    final userId = user.uid;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        top: false,

        child: Column(
          children: [
            const SizedBox(height: 10),

            /// HANDLE
            Container(
              width: 45,
              height: 5,

              decoration: BoxDecoration(
                color: Colors.grey.shade300,

                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 14),

            /// HEADER
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
                      child:
                          CircularProgressIndicator(),
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

                    /// NONAKTIF
                    if (data['isActive'] == false) {
                      return false;
                    }

                    /// QUOTA
                    if ((data['quota'] ?? 0) <= 0) {
                      return false;
                    }

                    /// EXPIRED
                    if (data['expiredAt'] == null) {
                      return false;
                    }

                    try {
                      final expiredAt =
                          (data['expiredAt']
                                  as Timestamp)
                              .toDate();

                      final today = DateTime(
                        now.year,
                        now.month,
                        now.day,
                      );

                      final expiredDateOnly =
                          DateTime(
                        expiredAt.year,
                        expiredAt.month,
                        expiredAt.day,
                      );

                      if (expiredDateOnly
                          .isBefore(today)) {
                        return false;
                      }
                    } catch (e) {
                      return false;
                    }

                    return true;
                  }).toList();

                  /// SORT TERBAIK
                  filteredDocs.sort((a, b) {
                    final aData =
                        a.data() as Map<String, dynamic>;

                    final bData =
                        b.data() as Map<String, dynamic>;

                    return (bData['discount'] ?? 0)
                        .compareTo(
                      aData['discount'] ?? 0,
                    );
                  });

                  /// AUTO APPLY BEST VOUCHER
                  if (selectedVoucherList.isEmpty &&
                      filteredDocs.isNotEmpty) {
                    for (var doc in filteredDocs) {
                      final data =
                          doc.data()
                              as Map<String, dynamic>;

                      final minPurchase =
                          data['minPurchase'] ?? 0;

                      if (widget.subtotal >=
                          minPurchase) {
                        selectedVoucherList.add({
                          'id': doc.id,
                          'code':
                              data['code'] ?? '',
                          'discountPercent':
                              data['discount'] ?? 0,
                          'minPurchase':
                              minPurchase,
                        });

                        break;
                      }
                    }
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    itemCount: filteredDocs.length,

                    itemBuilder: (context, index) {
                      final doc =
                          filteredDocs[index];

                      final data =
                          doc.data()
                              as Map<String, dynamic>;

                      final expiredDate =
                          (data['expiredAt']
                                  as Timestamp)
                              .toDate();

                      final minPurchase =
                          data['minPurchase'] ?? 0;

                      /// SUBTOTAL BELUM CUKUP
                      final isMinimumNotMet =
                          widget.subtotal <
                              minPurchase;

                      final isSelected =
                          isVoucherSelected(
                        doc.id,
                      );

                      final nominalDiskon =
                          ((widget.subtotal *
                                      (data['discount'] ??
                                          0)) /
                                  100)
                              .toInt();

                      return StreamBuilder<
                          DocumentSnapshot>(
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
                          final isAlreadyUsed =
                              claimSnapshot
                                      .hasData &&
                                  claimSnapshot
                                      .data!
                                      .exists;

                          final isDisabled =
                              isAlreadyUsed ||
                                  isMinimumNotMet;

                          return Opacity(
                            opacity:
                                isDisabled
                                ? 0.45
                                : 1,

                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 14,
                              ),

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  VoucherCard(
                                    isSelected:
                                        isSelected,

                                    title:
                                        data['code'] ??
                                            'PROMO',

                                    subTitle:
                                        isAlreadyUsed
                                        ? "Voucher sudah digunakan"
                                        : isMinimumNotMet
                                        ? "Minimal belanja Rp ${formatHarga(minPurchase)}"
                                        : "Diskon ${data['discount']}%",

                                    expiryDate:
                                        "${expiredDate.day}/${expiredDate.month}/${expiredDate.year}",

                                    minTransaction:
                                        "Min. Rp ${formatHarga(minPurchase)}",

                                    quota:
                                        isAlreadyUsed
                                        ? "Voucher Used"
                                        : "Sisa ${data['quota'] ?? 0}",

                                    discountAmount:
                                        nominalDiskon
                                            .toDouble(),

                                    buttonText:
                                        isAlreadyUsed
                                        ? "Sudah Dipakai"
                                        : isMinimumNotMet
                                        ? "Belum Memenuhi"
                                        : isSelected
                                        ? "Dipilih"
                                        : "Gunakan",

                                    onClaim:
                                        isDisabled
                                        ? null
                                        : () async {
                                            final voucherData =
                                                {
                                              'id':
                                                  doc.id,
                                              'code':
                                                  data['code'] ??
                                                      '',
                                              'discountPercent':
                                                  data['discount'] ??
                                                      0,
                                              'minPurchase':
                                                  minPurchase,
                                            };

                                            toggleVoucher(
                                              voucherData,
                                            );
                                          },
                                  ),

                                  /// WARNING
                                  if (isMinimumNotMet)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(
                                        left: 12,
                                        top: 6,
                                      ),

                                      child: Text(
                                        "Minimal belanja Rp ${formatHarga(minPurchase)}",
                                        style: const TextStyle(
                                          color:
                                              Colors.red,
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),
                                    ),
                                ],
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

            /// BUTTON APPLY
            Container(
              padding: const EdgeInsets.all(16),

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    selectedVoucherList,
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF7E8959),

                  minimumSize:
                      const Size(double.infinity, 54),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),

                child: Text(
                  selectedVoucherList.isEmpty
                      ? "Pilih Voucher"
                      : "Gunakan ${selectedVoucherList.length} Voucher",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}