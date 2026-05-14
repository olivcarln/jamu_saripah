import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamu_saripah/Models/order.dart'; // ✅ Pakai model yang benar

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<OrderModel> _orders = []; 
  int _userPoints = 0;

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

  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('created_at', descending: true) 
          .get();

      _orders = snapshot.docs.map((doc) {
        // ✅ Langsung pakai factory dari model sakti kamu
        return OrderModel.fromFirestore(doc);
      }).toList();
      
      notifyListeners();
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String address,
    required String userName,
    String? image,
  }) async {
    try {
      final newDoc = _firestore.collection('orders').doc();
      
      // ✅ Sesuaikan dengan field di OrderModel (toJson)
      final orderData = OrderModel(
        id: newDoc.id,
        userName: userName,
        totalAmount: totalPrice,
        status: 'Menunggu',
        paymentMethod: paymentMethod,
        address: address,
        paymentConfirmed: false,
        createdAt: DateTime.now(),
        items: items,
        image: image ?? '',
      );

      await newDoc.set(orderData.toJson());

      _userPoints += 4;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_points', _userPoints);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}