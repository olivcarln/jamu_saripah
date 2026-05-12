import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// OrderModel lo tetap sama seperti sebelumnya
class OrderModel {
  final String title;
  final String date;
  final int price;
  final String status;
  final String method;

  OrderModel({
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.method,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  int _userPoints = 0; // Variabel poin lo

  List<OrderModel> get orders => List.unmodifiable(_orders);
  int get userPoints => _userPoints;

  OrderProvider() {
    loadDataFromDevice(); // Load poin pas aplikasi baru jalan
  }

  // Fungsi simpan poin
  Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  // Fungsi ambil poin yang tersimpan
  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    
    // Tambah poin setiap ada order baru (misal: tiap order dapet 4 poin)
    _userPoints += 4; 
    
    savePoints(); // Simpan ke memori HP biar gak ilang
    notifyListeners();
  }

  // PENTING: Panggil ini kalau lo mau reset manual atau buat fitur logout tertentu
  void clearPoints() async {
    _userPoints = 0;
    await savePoints();
    notifyListeners();
  }
}