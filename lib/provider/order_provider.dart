import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamu_saripah/Models/order.dart';

export 'package:jamu_saripah/Models/order.dart';

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
          .orderBy('createdAt', descending: true)
          .get();
      _orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add({
        ...order.toJson(),
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

  Future<void> updateStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });
      await fetchOrders();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmPayment(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'paymentConfirmed': true,
      });
      await fetchOrders();
    } catch (e) {
      rethrow;
    }
  }
}