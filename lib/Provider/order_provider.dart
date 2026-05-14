import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jamu_saripah/Models/order.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

List<OrderModel> _orders = [];
  int _userPoints = 0;
  bool _isLoading = false;

  // =========================
  // GETTER
  // =========================

  List<OrderModel> get orders => List.unmodifiable(_orders);

  int get userPoints => _userPoints;

  bool get isLoading => _isLoading;

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

  // =========================
  // LOCAL STORAGE
  // =========================

  /// LOAD POINTS
  Future<void> loadDataFromDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _userPoints = prefs.getInt('user_points') ?? 0;

      notifyListeners();
    } catch (e) {
      debugPrint("Error load data: $e");
    }
  }

  /// SAVE POINTS
  Future<void> savePoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
        'user_points',
        _userPoints,
      );
    } catch (e) {
      debugPrint("Error save points: $e");
    }
  }

  /// RESET POINTS
  Future<void> clearPoints() async {
    _userPoints = 0;

    await savePoints();

    notifyListeners();
  }

  // =========================
  // ORDER STATE
  // =========================

  /// SET ORDER
  void setOrders(List<OrderModel> newOrders) {
    _orders
      ..clear()
      ..addAll(newOrders);

    notifyListeners();
  }

  /// CLEAR ORDER
  void clearOrders() {
    _orders.clear();

    notifyListeners();
  }

  // =========================
  // FIRESTORE
  // =========================

  /// ADD ORDER
  Future<void> addOrder(OrderModel order) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());

      _orders.insert(0, order);

      /// TAMBAH POINTS
      _userPoints += 4;

      await savePoints();

      notifyListeners();

      debugPrint("Order berhasil ditambahkan");
    } catch (e) {
      debugPrint("Error add order: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// FETCH ORDERS
  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('orders')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .get();

      final loadedOrders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();

      _orders
        ..clear()
        ..addAll(loadedOrders);

      notifyListeners();

      debugPrint("Fetch order berhasil");
    } catch (e) {
      debugPrint("Error fetch orders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE STATUS
  Future<void> updateStatus(
    String orderId,
    String status,
  ) async {
    try {
      await _firestore
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
  Future<void> confirmPayment(
    String orderId,
  ) async {
    try {
      await _firestore
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
