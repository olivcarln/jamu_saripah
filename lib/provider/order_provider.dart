import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jamu_saripah/Models/order.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  int _userPoints = 0;

  int get userPoints => _userPoints;
  List<OrderModel> get orders => _orders;

  OrderProvider() {
    loadDataFromDevice();
    fetchOrders();
  }

  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  /// =========================
  /// FETCH ORDER FIRESTORE
  /// =========================
  Future<void> fetchOrders() async {
    try {
      // DISESUAIKAN: Koleksi 'orders' dan field 'created_at' sesuai screenshot
      final snapshot = await _firestore
          .collection('orders') 
          .orderBy('created_at', descending: true) 
          .get();

      _orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetchOrders: $e");
    }
  }

  /// =========================
  /// ADD ORDER
  /// =========================
  /// =========================
  /// ADD ORDER
  /// =========================
  Future<void> addOrder(OrderModel order) async {
    try {
      final orderData = {
        'id': order.id,
        'userId': order.userId,
        'userName': order.userName, // <--- Pastikan ini ada
        'userEmail': order.userEmail,
        'totalAmount': order.totalAmount,
        'status': order.status,
        'paymentMethod': order.paymentMethod,
        'address': order.address,
        'created_at': Timestamp.fromDate(order.createdAt), 
        'items': order.items,
        'image': order.image,
        'paymentConfirmed': order.paymentConfirmed,
      };

      await _firestore
          .collection('orders') // Sesuai koleksi di screenshot kamu
          .doc(order.id)
          .set(orderData);

      // ... sisa kode poin dan local insert
      notifyListeners();
      await fetchOrders();
    } catch (e) {
      debugPrint("Add order error: $e");
      rethrow;
    }
  }

  /// =========================
  /// UPDATE STATUS
  /// =========================
  Future<void> updateStatus(String orderId, String status) async {
    try {
      if (orderId.trim().isEmpty) return;

      // DISESUAIKAN: Koleksi 'orders'
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'status': status});

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: status);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Update status error: $e");
      rethrow;
    }
  }

  /// =========================
  /// CONFIRM PAYMENT
  /// =========================
  Future<void> confirmPayment(String orderId) async {
    try {
      // DISESUAIKAN: Koleksi 'orders'
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'paymentConfirmed': true,
        'status': 'Diproses',
      });

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          paymentConfirmed: true,
          status: 'Diproses',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Confirm payment error: $e");
      rethrow;
    }
  }

  /// =========================
  /// GET USER ORDERS
  /// =========================
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      // DISESUAIKAN: Koleksi 'orders' dan field 'created_at'
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint("Get user orders error: $e");
      return [];
    }
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}