import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminVoucherScreen extends StatefulWidget {
  const AdminVoucherScreen({super.key});

  @override
  State<AdminVoucherScreen> createState() => _AdminVoucherScreenState();
}

class _AdminVoucherScreenState extends State<AdminVoucherScreen> {
  /// DELETE VOUCHER
  void _deleteVoucher(String voucherId, String code) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text("Hapus Voucher"),

        content: Text("Apakah kamu yakin ingin menghapus voucher $code?"),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),

            child: const Text("Batal"),
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
                  const SnackBar(content: Text("Voucher berhasil dihapus")),
                );
              } catch (e) {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
              }
            },

            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// DIALOG ADD / EDIT
  void _showVoucherDialog({
    String? voucherId,
    Map<String, dynamic>? data,
    DocumentReference? reference,
  }) {
    final codeController = TextEditingController(text: data?['code'] ?? '');

    final discountController = TextEditingController(
      text: data?['discount']?.toString() ?? '',
    );

    final minPurchaseController = TextEditingController(
      text: data?['minPurchase']?.toString() ?? '',
    );

    final quotaController = TextEditingController(
      text: data?['quota']?.toString() ?? '',
    );

    bool isUsed = data?['isUsed'] ?? false;

    DateTime? expiredDate = data?['expiredAt'] != null
        ? (data!['expiredAt'] as Timestamp).toDate()
        : null;

    showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                voucherId == null ? "Tambah Voucher" : "Edit Voucher",
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    /// CODE
                    TextField(
                      controller: codeController,

                      decoration: const InputDecoration(
                        labelText: "Kode Voucher",
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// DISCOUNT
                    TextField(
                      controller: discountController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Diskon (%)",
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// MIN PURCHASE
                    TextField(
                      controller: minPurchaseController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Minimum Belanja",
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// QUOTA
                    TextField(
                      controller: quotaController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Kuota Voucher",
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// EXPIRED DATE
                    SizedBox(
                      width: double.infinity,

                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_month),

                        label: Text(
                          expiredDate == null
                              ? "Pilih Tanggal Expired"
                              : "${expiredDate!.day}/${expiredDate!.month}/${expiredDate!.year}",
                        ),

                        onPressed: () async {
                          final pickedDate = await showDatePicker(
                            context: context,

                            initialDate: DateTime.now(),

                            firstDate: DateTime.now(),

                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              expiredDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// STATUS
                    SwitchListTile(
                      value: isUsed,

                      onChanged: (value) {
                        setState(() {
                          isUsed = value;
                        });
                      },

                      title: const Text("Sudah dipakai"),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),

                  child: const Text("Batal"),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E8959),
                  ),

                  onPressed: () async {
                    try {
                      final voucherData = {
                        'code': codeController.text,

                        'discount': int.tryParse(discountController.text) ?? 0,

                        'minPurchase':
                            int.tryParse(minPurchaseController.text) ?? 0,

                        'quota': int.tryParse(quotaController.text) ?? 0,

                        'isUsed': isUsed,

                        'expiredAt': expiredDate,

                        'updatedAt': FieldValue.serverTimestamp(),
                      };

                      /// ADD
                      if (voucherId == null) {
                        await FirebaseFirestore.instance
                            .collection('global_vouchers')
                            .add({
                              ...voucherData,

                              'createdAt': FieldValue.serverTimestamp(),
                            });
                      } else {
                        /// UPDATE
                        await reference!.update(voucherData);
                      }

                      if (!mounted) return;

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            voucherId == null
                                ? "Voucher berhasil ditambahkan"
                                : "Voucher berhasil diupdate",
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },

                  child: Text(voucherId == null ? "Tambah" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),

      appBar: AppBar(
        title: const Text(
          "Kelola Voucher",
          style: TextStyle(color: Colors.white),
        ),

        backgroundColor: const Color(0xFF7E8959),
      ),

      body: StreamBuilder<QuerySnapshot>(
        /// AUTO FILTER EXPIRED
        stream: FirebaseFirestore.instance
            .collection('global_vouchers')
            .where('expiredAt', isGreaterThan: Timestamp.now())
            .orderBy('expiredAt')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7E8959)),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan voucher"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada voucher"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: docs.length,

            itemBuilder: (context, index) {
              final doc = docs[index];

              final data = doc.data() as Map<String, dynamic>;

              final expiredAt = (data['expiredAt'] as Timestamp).toDate();

              return Container(
                margin: const EdgeInsets.only(bottom: 15),

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,

                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: const Icon(
                            Icons.discount,

                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                data['code'] ?? 'Voucher',

                                style: const TextStyle(
                                  fontSize: 16,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text("Diskon ${data['discount']}%"),

                              Text("Min Belanja Rp ${data['minPurchase']}"),

                              Text("Kuota ${data['quota']}"),

                              Text(
                                "Expired: ${expiredAt.day}/${expiredAt.month}/${expiredAt.year}",
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,

                            vertical: 5,
                          ),

                          decoration: BoxDecoration(
                            color: data['isUsed'] == true
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            data['isUsed'] == true ? "Used" : "Active",

                            style: TextStyle(
                              color: data['isUsed'] == true
                                  ? Colors.red
                                  : Colors.green,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,

                      children: [
                        /// EDIT
                        IconButton(
                          icon: const Icon(
                            Icons.edit,

                            color: Color(0xFF7E8959),
                          ),

                          onPressed: () {
                            _showVoucherDialog(
                              voucherId: doc.id,

                              data: data,

                              reference: doc.reference,
                            );
                          },
                        ),

                        /// DELETE
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            _deleteVoucher(doc.id, data['code']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7E8959),

        child: const Icon(Icons.add, color: Colors.white),

        onPressed: () {
          _showVoucherDialog();
        },
      ),
    );
  }
}
