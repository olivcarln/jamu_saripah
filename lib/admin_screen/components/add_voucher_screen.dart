import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddVoucherScreen extends StatefulWidget {
  const AddVoucherScreen({super.key});

  @override
  State<AddVoucherScreen> createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  final _minPurchaseController = TextEditingController();

  DateTime? _expiredDate;
  bool _isLoading = false;

  Future<void> _pickExpiredDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _expiredDate = picked;
      });
    }
  }

  Future<void> _saveVoucher() async {
    if (_codeController.text.isEmpty ||
        _discountController.text.isEmpty ||
        _minPurchaseController.text.isEmpty ||
        _expiredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi semua field dulu ya'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User belum login');
      }

      final voucherRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('vouchers')
          .doc();

      await voucherRef.set({
        'code': _codeController.text.trim(),
        'discount': int.tryParse(_discountController.text) ?? 0,
        'minPurchase': int.tryParse(_minPurchaseController.text) ?? 0,
        'expiredAt': Timestamp.fromDate(_expiredDate!),
        'createdAt': FieldValue.serverTimestamp(),
        'isUsed': false,
      });

      if (mounted) {
        Navigator.pop(context);
      }
} catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan voucher: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _minPurchaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Voucher'),
        backgroundColor: const Color(0xFF7E8959),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'Kode Voucher'),
            ),
            TextField(
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Diskon (%)'),
            ),
            TextField(
              controller: _minPurchaseController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Minimal Pembelian'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(_expiredDate == null
                      ? 'Pilih tanggal kadaluarsa'
                      : 'Kadaluarsa: ${_expiredDate!.toLocal()}'
                          .split(' ')[0]),
                ),
                ElevatedButton(
                  onPressed: _pickExpiredDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E8959),
                  ),
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveVoucher,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E8959),
                minimumSize: const Size(double.infinity, 50),
              ),
              child:
                  _isLoading ? const CircularProgressIndicator() : const Text('Simpan Voucher'),
            ),
          ],
        ),
      ),
    );
  }
}