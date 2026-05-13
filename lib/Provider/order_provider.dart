import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderModel {
  final String title;
  final String date;
  final int price;
  final String status;
  final String method;
  final String location; // Tambah ini biar data lokasi gak ilang

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
    loadDataFromDevice();
  }

  Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  // DISINI PERBAIKANNYA: Sesuaikan parameter agar matching dengan CheckoutScreen
  void addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String location,
  }) {
    // 1. Buat nama/title order (misal: ambil nama item pertama)
    String orderTitle = items.isNotEmpty ? items[0]['name'] : 'Pesanan Jamu';
    if (items.length > 1) orderTitle += ' +${items.length - 1} lainnya';

    // 2. Bungkus ke dalam OrderModel
    final newOrder = OrderModel(
      title: orderTitle,
      date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      price: totalPrice,
      status: 'Sedang Diproses',
      method: paymentMethod,
      location: location,
    );

    // 3. Masukkan ke list
    _orders.insert(0, newOrder);
    
    // 4. Update Poin
    _userPoints += 4; 
    
    savePoints();
    notifyListeners();
  }

  void clearPoints() async {
    _userPoints = 0;
    await savePoints();
    notifyListeners();
  }
}