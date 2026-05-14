import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- Import ini penting!

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<OrderModel> _orders = [];
  int _userPoints = 0;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  int get userPoints => _userPoints;

  OrderProvider() {
    loadDataFromDevice();
  }

  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  // Fungsi async untuk simpan ke Firestore
  Future<void> addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String location,
  }) async {
    try {
      String orderTitle = items.isNotEmpty ? items[0]['name'] : 'Pesanan Jamu';
      if (items.length > 1) orderTitle += ' +${items.length - 1} lainnya';

      // SIMPAN KE CLOUD FIRESTORE
      await _firestore.collection('orders').add({
        'title': orderTitle,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'location': location,
        'status': 'Sedang Diproses',
        'createdAt': FieldValue.serverTimestamp(),
        'items': items,
      });

      // UPDATE LOKAL & POINT
      _orders.insert(0, OrderModel(
        title: orderTitle,
        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        price: totalPrice,
        status: 'Sedang Diproses',
        method: paymentMethod,
        location: location,
      ));

      _userPoints += 4;
      await savePoints();
      notifyListeners();
    } catch (e) {
      print("Error Firestore: $e");
      rethrow;
    }
  }

  void clearPoints() async {
    _userPoints = 0;
    await savePoints();
    notifyListeners();
  }
}