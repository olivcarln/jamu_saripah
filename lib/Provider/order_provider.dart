import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamu_saripah/Models/order.dart';

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

      _orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  // ✅ BUAT ADMIN: Update Status Pesanan
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      
      int index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // ✅ BUAT ADMIN: Konfirmasi Pembayaran
  Future<void> confirmPayment(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'payment_confirmed': true,
      });

      int index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(paymentConfirmed: true);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // ✅ BUAT USER: Tambah Pesanan Baru
  Future<void> addOrder({
    required List<Map<String, dynamic>> items,
    required int totalPrice,
    required String paymentMethod,
    required String address,
    required String userName,
    String? email,
    String? notes,
    String? image,
  }) async {
    try {
      final newDoc = _firestore.collection('orders').doc();
      
      final orderData = OrderModel(
        id: newDoc.id,
        userName: userName,
        userEmail: email,
        totalAmount: totalPrice,
        status: 'Menunggu',
        paymentMethod: paymentMethod,
        address: address,
        paymentConfirmed: false,
        createdAt: DateTime.now(),
        items: items,
        image: image ?? '',
        notes: notes,
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