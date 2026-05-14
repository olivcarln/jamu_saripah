import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/common/constasts.dart';

class AdminVoucherScreen extends StatefulWidget {
  const AdminVoucherScreen({super.key});

  @override
  State<AdminVoucherScreen> createState() => _AdminVoucherScreenState();
}

class _AdminVoucherScreenState extends State<AdminVoucherScreen> {
  /// DETAIL VOUCHER
  void _showVoucherDetail(Map<String, dynamic> data, DateTime expiredAt) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E8959).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    color: Color(0xFF7E8959),
                    size: 40,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  data['code']?.toString().toUpperCase() ?? '-',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const Text(
                  "KODE VOUCHER PROMO",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(),
                ),

                _buildPopupRow(
                  Icons.percent,
                  "Diskon",
                  "${data['discount']}%",
                ),

                const SizedBox(height: 12),

                _buildPopupRow(
                  Icons.shopping_bag_outlined,
                  "Min. Belanja",
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(data['minPurchase']),
                ),

                const SizedBox(height: 12),

                _buildPopupRow(
                  Icons.people_outline,
                  "Sisa Kuota",
                  "${data['quota']}x",
                ),

                const SizedBox(height: 12),

                _buildPopupRow(
                  Icons.event_available,
                  "Berlaku Sampai",
                  "${expiredAt.day}/${expiredAt.month}/${expiredAt.year}",
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7E8959),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Tutup Detail",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  /// DELETE VOUCHER
  void _deleteVoucher(String voucherId, String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Hapus Voucher"),
        content: Text(
          "Apakah kamu yakin ingin menghapus voucher $code?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey),),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('global_vouchers')
                    .doc(voucherId)
                    .delete();

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Voucher berhasil dihapus"),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal menghapus: $e"),
                  ),
                );
              }
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// DIALOG TAMBAH / EDIT
  void _showVoucherDialog({
    String? voucherId,
    Map<String, dynamic>? data,
    DocumentReference? reference,
  }) {
    final codeController = TextEditingController(
      text: data?['code'] ?? '',
    );

    final discountController = TextEditingController(
      text: data?['discount']?.toString() ?? '',
    );

    final minPurchaseController = TextEditingController(
      text: data?['minPurchase']?.toString() ?? '',
    );

    final quotaController = TextEditingController(
      text: data?['quota']?.toString() ?? '',
    );

    DateTime? expiredDate = data?['expiredAt'] != null
        ? (data!['expiredAt'] as Timestamp).toDate()
        : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(
            voucherId == null
                ? "Tambah Voucher"
                : "Edit Voucher",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(
                  codeController,
                  "Kode Voucher",
                  Icons.vpn_key_outlined,
                ),

                const SizedBox(height: 16),

                _buildField(
                  discountController,
                  "Diskon (%)",
                  Icons.percent_rounded,
                  isNumber: true,
                ),

                const SizedBox(height: 16),

                _buildField(
                  minPurchaseController,
                  "Min. Belanja",
                  Icons.shopping_bag_outlined,
                  isNumber: true,
                ),

                const SizedBox(height: 16),

                _buildField(
                  quotaController,
                  "Kuota Voucher",
                  Icons.confirmation_number_outlined,
                  isNumber: true,
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        expiredDate = picked;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: Color(0xFF7E8959),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            expiredDate == null
                                ? "Pilih Tanggal Expired"
                                : "${expiredDate!.day}/${expiredDate!.month}/${expiredDate!.year}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
   child: const Text("Batal", style: TextStyle(color: Colors.grey),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E8959),
              ),
              onPressed: () async {
                final vData = {
                  'code': codeController.text,
                  'discount':
                      int.tryParse(discountController.text) ?? 0,
                  'minPurchase':
                      int.tryParse(minPurchaseController.text) ?? 0,
                  'quota':
                      int.tryParse(quotaController.text) ?? 0,
                  'expiredAt': expiredDate,
                  'updatedAt': FieldValue.serverTimestamp(),
                };

                if (voucherId == null) {
                  await FirebaseFirestore.instance
                      .collection('global_vouchers')
                      .add({
                    ...vData,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                } else {
                  await reference!.update(vData);
                }

                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
          isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF7E8959),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),

      /// FLOATING BUTTON
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF7E8959),
          elevation: 8,
          shape: const CircleBorder(),
          onPressed: () => _showVoucherDialog(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('global_vouchers')
            .where(
              'expiredAt',
              isGreaterThan: Timestamp.now(),
            )
            .orderBy('expiredAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7E8959),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("Belum ada voucher aktif"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              120,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              final data =
                  doc.data() as Map<String, dynamic>;

              final expiredAt =
                  (data['expiredAt'] as Timestamp).toDate();

              return GestureDetector(
                onTap: () =>
                    _showVoucherDetail(data, expiredAt),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      /// ICON BOX
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color:
                              Colors.green.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.discount_rounded,
                          color: AppColors.primaryOlive,
                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['code'] ?? 'Voucher',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "Diskon ${data['discount']}%",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildBadge(
                                  "Min ${NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(data['minPurchase'])}",
                                  Colors.orange,
                                ),

                                _buildBadge(
                                  "Kuota ${data['quota']}",
                                  Colors.green,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Expired ${expiredAt.day}/${expiredAt.month}/${expiredAt.year}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// ACTIONS
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF7E8959,
                              ).withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              constraints:
                                  const BoxConstraints(),
                              padding: const EdgeInsets.all(10),
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Color(0xFF7E8959),
                                size: 22,
                              ),
                              onPressed: () =>
                                  _showVoucherDialog(
                                voucherId: doc.id,
                                data: data,
                                reference: doc.reference,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.red.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              constraints:
                                  const BoxConstraints(),
                              padding: const EdgeInsets.all(10),
                              icon: const Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                                size: 22,
                              ),
                              onPressed: () =>
                                  _deleteVoucher(
                                doc.id,
                                data['code'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}