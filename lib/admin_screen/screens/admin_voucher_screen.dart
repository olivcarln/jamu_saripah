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
  
  /// --- DETAIL VOUCHER POPUP ---
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
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(),
                ),
                _buildPopupRow(Icons.percent, "Diskon", "${data['discount']}%"),
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
                _buildPopupRow(Icons.confirmation_number_outlined, "Kuota Global", "${data['quota']}x"),
                const SizedBox(height: 12),
                
                // DETAIL KUOTA PER USER
                _buildPopupRow(
                  Icons.person_pin_rounded, 
                  "Kuota Per User", 
                  "${data['maxUsagePerUser'] ?? 1}x"
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup Detail", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: Colors.grey))),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ],
    );
  }

  /// --- DELETE LOGIC ---
  void _deleteVoucher(String voucherId, String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Hapus Voucher"),
        content: Text("Apakah kamu yakin ingin menghapus voucher $code?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('global_vouchers').doc(voucherId).delete();
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voucher dihapus")));
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// --- ADD / EDIT DIALOG ---
  void _showVoucherDialog({String? voucherId, Map<String, dynamic>? data, DocumentReference? reference}) {
    final codeController = TextEditingController(text: data?['code'] ?? '');
    final discountController = TextEditingController(text: data?['discount']?.toString() ?? '');
    final minPurchaseController = TextEditingController(text: data?['minPurchase']?.toString() ?? '');
    
    // Controller untuk kuota per user
    final maxUsageController = TextEditingController(
      text: data?['maxUsagePerUser']?.toString() ?? '1',
    );

    DateTime? expiredDate = data?['expiredAt'] != null ? (data!['expiredAt'] as Timestamp).toDate() : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: Text(voucherId == null ? "Tambah Voucher" : "Edit Voucher", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(codeController, "Kode Voucher", Icons.vpn_key_outlined),
                const SizedBox(height: 16),
                _buildField(discountController, "Diskon (%)", Icons.percent_rounded, isNumber: true),
                const SizedBox(height: 16),
                _buildField(minPurchaseController, "Min. Belanja", Icons.shopping_bag_outlined, isNumber: true),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                
                // INPUT FIELD KUOTA PER USER
                _buildField(maxUsageController, "Batas Pakai Per User", Icons.person_outline, isNumber: true),
                
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => expiredDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF7E8959)),
                        const SizedBox(width: 12),
                        Text(expiredDate == null ? "Pilih Tanggal Expired" : DateFormat('dd/MM/yyyy').format(expiredDate!)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7E8959)),
              onPressed: () async {
                final vData = {
                  'code': codeController.text,
                  'discount': int.tryParse(discountController.text) ?? 0,
                  'minPurchase': int.tryParse(minPurchaseController.text) ?? 0,
                  'maxUsagePerUser': int.tryParse(maxUsageController.text) ?? 1, // Simpan sebagai int
                  'expiredAt': expiredDate,
                  'updatedAt': FieldValue.serverTimestamp(),
                };

                if (voucherId == null) {
                  await FirebaseFirestore.instance.collection('global_vouchers').add({...vData, 'createdAt': FieldValue.serverTimestamp()});
                } else {
                  await reference!.update(vData);
                }
                Navigator.pop(context);
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF7E8959)),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  /// --- MAIN BUILDER ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF7),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF7E8959),
          onPressed: () => _showVoucherDialog(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('global_vouchers')
            .where('expiredAt', isGreaterThan: Timestamp.now())
            .orderBy('expiredAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("Tidak ada voucher aktif"));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final expiredAt = (data['expiredAt'] as Timestamp).toDate();

              return GestureDetector(
                onTap: () => _showVoucherDetail(data, expiredAt),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.discount_rounded, color: Color(0xFF7E8959)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['code'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Diskon ${data['discount']}%", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 5,
                              children: [
                                _buildBadge("Limit: ${data['maxUsagePerUser'] ?? 1}x/user", Colors.blue),
                                _buildBadge("Sisa: ${data['quota']}x", Colors.green),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Color(0xFF7E8959)),
                        onPressed: () => _showVoucherDialog(voucherId: doc.id, data: data, reference: doc.reference),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteVoucher(doc.id, data['code']),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}