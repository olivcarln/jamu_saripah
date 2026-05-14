import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamu_saripah/Models/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];
  int _userPoints = 0;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  int get userPoints => _userPoints;

  /// LIST STATUS ORDER
  final List<String> orderStatuses = [
    "Menunggu",
    "Diproses",
    "Menunggu Pengambilan",
    "Selesai",
    "Dibatalkan",
  ];

  OrderProvider() {
    loadDataFromDevice();
  }

  /// LOAD POINTS DARI DEVICE
  Future<void> loadDataFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    _userPoints = prefs.getInt('user_points') ?? 0;
    notifyListeners();
  }

  /// SIMPAN POINTS
  Future<void> savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', _userPoints);
  }

  /// RESET POINTS
  Future<void> clearPoints() async {
    _userPoints = 0;
    await savePoints();
    notifyListeners();
  }

  /// SET ORDER
  void setOrders(List<OrderModel> newOrders) {
    _orders.clear();
    _orders.addAll(newOrders);
    notifyListeners();
  }

  /// ADD ORDER
  Future<void> addOrder(OrderModel order) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .set(order.toMap());

      _orders.insert(0, order);

      /// TAMBAH POINTS
      _userPoints += 4;
      await savePoints();

      notifyListeners();
    } catch (e) {
      debugPrint("Error add order: $e");
      rethrow;
    }
  }

  /// FETCH ORDER
  Future<void> fetchOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final loadedOrders = snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc);
      }).toList();

      _orders.clear();
      _orders.addAll(loadedOrders);

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch orders: $e");
    }
  }

  /// UPDATE STATUS
  Future<void> updateStatus(
    String orderId,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': status,
      });

      final index = _orders.indexWhere(
        (order) => order.id == orderId,
      );

      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: status,
        );

        notifyListeners();
      }

      debugPrint(
        "Status berhasil diubah menjadi $status",
      );
    } catch (e) {
      debugPrint("Error update status: $e");
      rethrow;
    }
  }

  /// KONFIRMASI PEMBAYARAN
  Future<void> confirmPayment(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'paymentConfirmed': true,
      });

      final index = _orders.indexWhere(
        (order) => order.id == orderId,
      );

      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          paymentConfirmed: true,
        );

        notifyListeners();
      }

      debugPrint(
        "Pembayaran berhasil dikonfirmasi",
      );
    } catch (e) {
      debugPrint("Error confirm payment: $e");
      rethrow;
    }
  }
}