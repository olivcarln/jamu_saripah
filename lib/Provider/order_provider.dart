import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderModel {
  final String title;
  final String date;
  final int price;
  final String status;
  final String method;
  final String location;

  OrderModel({
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.method,
    required this.location,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  int _userPoints = 0;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  int get userPoints => _userPoints;

  OrderProvider() {
    loadDataFromDevice(); // Otomatis ambil poin pas aplikasi nyala
  }

  // Ambil poin dari memori HP
  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  // Simpan poin ke memori HP
  Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  // Fungsi dipanggil SAAT CHECKOUT SELESAI
  void addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String location,
  }) {
    // Buat title otomatis
    String orderTitle = items.isNotEmpty ? items[0]['name'] : 'Pesanan Jamu';
    if (items.length > 1) orderTitle += ' +${items.length - 1} lainnya';

    final newOrder = OrderModel(
      title: orderTitle,
      date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      price: totalPrice,
      status: 'Sedang Diproses',
      method: paymentMethod,
      location: location,
    );

    _orders.insert(0, newOrder);
    
    // POIN BARU NAMBAH DI SINI (Pas pesanan dibuat)
    _userPoints += 4; 
    
    savePoints(); // Simpan biar gak ilang pas logout
    notifyListeners();
  }

  // Gunakan ini kalau bener-bener mau hapus poin (misal reset data)
  void clearPoints() async {
    _userPoints = 0;
    await savePoints();
    notifyListeners();
  }
}