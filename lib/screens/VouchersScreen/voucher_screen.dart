import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_card.dart';
import 'package:jamu_saripah/screens/VouchersScreen/component/voucher_header.dart';

class VoucherScreen extends StatefulWidget {
  final Map<String, dynamic>? selectedVoucher;
  final int subtotal;
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
  List<Map<String, dynamic>> selectedVoucherList = [];

  @override
  void initState() {
    super.initState();
    // Sinkronisasi data awal dari screen sebelumnya
    selectedVoucherList = [...widget.selectedVouchers];
    if (widget.selectedVoucher != null && !isVoucherSelected(widget.selectedVoucher!['id'])) {
      selectedVoucherList.add(widget.selectedVoucher!);
    }
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  bool isVoucherSelected(String id) {
    return selectedVoucherList.any((voucher) => voucher['id'] == id);
  }

  void toggleVoucher(Map<String, dynamic> voucher) {
    final alreadySelected = isVoucherSelected(voucher['id']);
    setState(() {
      if (alreadySelected) {
        selectedVoucherList.removeWhere((item) => item['id'] == voucher['id']);
      } else {
        // JIKA sistem kamu hanya memperbolehkan 1 voucher per transaksi, aktifkan line di bawah ini:
        // selectedVoucherList.clear(); 
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: const Center(child: Text("Silakan login terlebih dahulu")),
      );
    }

    final userId = user.uid;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 45, height: 5,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
            ),
            const SizedBox(height: 14),
            VoucherHeader(isVoucherActive: true, onPaydayTap: () {}),
            const Divider(height: 1),
            Expanded(
              // STREAM 1: Mengambil seluruh riwayat voucher yang pernah diklaim user
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('claimed_vouchers')
                    .snapshots(),
                builder: (context, userClaimsSnapshot) {
                  if (userClaimsSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Petakan data klaim ke dalam Map [voucherId: usageCount] untuk pencarian instan
                  final Map<String, int> userUsageMap = {};
                  if (userClaimsSnapshot.hasData) {
                    for (var doc in userClaimsSnapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      userUsageMap[doc.id] = data['usageCount'] ?? 0;
                    }
                  }

                  // STREAM 2: Mengambil Global Vouchers
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('global_vouchers').snapshots(),
                    builder: (context, globalVouchersSnapshot) {
                      if (globalVouchersSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!globalVouchersSnapshot.hasData || globalVouchersSnapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Belum ada voucher tersedia"));
                      }

                      final now = DateTime.now();
                      final filteredDocs = globalVouchersSnapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        if (data['isActive'] == false) return false;
                        if ((data['quota'] ?? 0) <= 0) return false;
                        if (data['expiredAt'] == null) return false;

                        try {
                          final expiredAt = (data['expiredAt'] as Timestamp).toDate();
                          final today = DateTime(now.year, now.month, now.day);
                          if (DateTime(expiredAt.year, expiredAt.month, expiredAt.day).isBefore(today)) return false;
                        } catch (e) { return false; }
                        return true;
                      }).toList();

                      // Urutkan Diskon Tertinggi
                      filteredDocs.sort((a, b) => ((b.data() as Map)['discount'] ?? 0).compareTo((a.data() as Map)['discount'] ?? 0));

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final expiredDate = (data['expiredAt'] as Timestamp).toDate();
                          final minPurchase = data['minPurchase'] ?? 0;
                          final maxUsagePerUser = data['maxUsagePerUser'] ?? 1;

                          final isMinimumNotMet = widget.subtotal < minPurchase;
                          final isSelected = isVoucherSelected(doc.id);
                          final nominalDiskon = ((widget.subtotal * (data['discount'] ?? 0)) / 100).toInt();

                          // Ambil hitungan pemakaian langsung dari Map tanpa panggil Stream/Future lagi
                          final userUsageCount = userUsageMap[doc.id] ?? 0;
                          final bool isLimitReached = userUsageCount >= maxUsagePerUser;
                          final isDisabled = isLimitReached || isMinimumNotMet;

                          return Opacity(
                            opacity: isDisabled ? 0.45 : 1,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VoucherCard(
                                    isSelected: isSelected,
                                    title: data['code'] ?? 'PROMO',
                                    subTitle: isLimitReached
                                        ? "Limit pemakaian tercapai ($userUsageCount/$maxUsagePerUser)"
                                        : isMinimumNotMet
                                            ? "Minimal belanja Rp ${formatHarga(minPurchase)}"
                                            : "Diskon ${data['discount']}%",
                                    expiryDate: "${expiredDate.day}/${expiredDate.month}/${expiredDate.year}",
                                    minTransaction: "Min. Rp ${formatHarga(minPurchase)}",
                                    quota: isLimitReached ? "Limit Habis" : "Sisa Kuota: ${data['quota'] ?? 0}",
                                    discountAmount: nominalDiskon.toDouble(),
                                    buttonText: isLimitReached
                                        ? "Sudah Limit"
                                        : isMinimumNotMet
                                            ? "Belum Memenuhi"
                                            : isSelected
                                                ? "Dipilih"
                                                : "Gunakan",
                                    onClaim: isDisabled
                                        ? null
                                        : () {
                                            toggleVoucher({
                                              'id': doc.id,
                                              'code': data['code'] ?? '',
                                              'discountPercent': data['discount'] ?? 0,
                                              'minPurchase': minPurchase,
                                            });
                                          },
                                  ),
                                  if (isMinimumNotMet)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, top: 6),
                                      child: Text(
                                        "Minimal belanja Rp ${formatHarga(minPurchase)}",
                                        style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
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
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, selectedVoucherList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E8959),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  selectedVoucherList.isEmpty
                      ? "Pilih Voucher"
                      : "Gunakan ${selectedVoucherList.length} Voucher",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}