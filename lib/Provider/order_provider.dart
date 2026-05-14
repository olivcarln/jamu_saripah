import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<OrderModel> _orders = [];
  int _userPoints = 0;

  // Getter ini wajib ada buat Screenshot 652 (Home Header)
  int get userPoints => _userPoints;
  List<OrderModel> get orders => _orders;

  OrderProvider() {
    loadDataFromDevice();
  }

  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  // Method ini wajib ada buat Screenshot 653 (History)
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel(
          title: data['title'] ?? 'Jamu',
          date: data['date'] ?? '',
          price: data['totalPrice'] ?? 0,
          status: data['status'] ?? 'Proses',
          method: data['paymentMethod'] ?? 'Tunai',
          location: data['location'] ?? '',
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String location,
  }) async {
    try {
      String orderTitle = items.isNotEmpty ? items[0]['name'] : 'Pesanan Jamu';
      if (items.length > 1) orderTitle += ' +${items.length - 1} lainnya';

      await _firestore.collection('orders').add({
        'title': orderTitle,
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'location': location,
        'status': 'Sedang Diproses',
        'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        'createdAt': FieldValue.serverTimestamp(),
      });

      _userPoints += 4;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_points', _userPoints);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}