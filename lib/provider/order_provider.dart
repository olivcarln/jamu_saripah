import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jamu_saripah/Models/order.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  List<OrderModel> _orders = [];

  int _userPoints = 0;

  /// GETTER
  List<OrderModel> get orders => _orders;

  int get userPoints => _userPoints;

  OrderProvider() {
    loadDataFromDevice();
  }

  /// LOAD POINTS
  Future<void> loadDataFromDevice() async {
    final prefs =
        await SharedPreferences.getInstance();

    _userPoints =
        prefs.getInt('user_points') ?? 0;

    notifyListeners();
  }

  /// FETCH ORDERS
  Future<void> fetchOrders() async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('orders')
              .orderBy(
                'created_at',
                descending: true,
              )
              .get();

      _orders =
          snapshot.docs
              .map(
                (doc) =>
                    OrderModel.fromFirestore(doc),
              )
              .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("ERROR FETCH ORDER: $e");
    }
  }

  /// ADD ORDER
  Future<void> addOrder(
    OrderModel order,
  ) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());

      _orders.insert(0, order);

      /// TAMBAH POINT
      _userPoints += 4;

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setInt(
        'user_points',
        _userPoints,
      );

      notifyListeners();
    } catch (e) {
      debugPrint("ERROR ADD ORDER: $e");
      rethrow;
    }
  }
Future<void> confirmPayment(String orderId) async {
  try {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({
          'payment_confirmed': true,
        });

    final index = _orders.indexWhere(
      (o) => o.id == orderId,
    );

    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        paymentConfirmed: true,
      );

      notifyListeners();
    }
  } catch (e) {
    debugPrint("ERROR CONFIRM PAYMENT: $e");
    rethrow;
  }
}
  /// UPDATE STATUS
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({
            'status': newStatus,
          });

      final index = _orders.indexWhere(
        (o) => o.id == orderId,
      );

      if (index != -1) {
        _orders[index] = _orders[index]
            .copyWith(status: newStatus);

        notifyListeners();
      }
    } catch (e) {
      debugPrint("ERROR UPDATE STATUS: $e");
    }
  }
}