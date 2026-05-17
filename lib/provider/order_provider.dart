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
      final snapshot = await _firestore
          .collection('orders') 
          .orderBy('createdAt', descending: true) 
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
  /// ADD ORDER (FIXED MAPPING)
  /// =========================
  Future<void> addOrder(OrderModel order) async {
    try {
      // FIX UTAMA: Memaksa pemetaan ulang array ke List<Map> murni tepat sebelum menyentuh Firestore.
      // Langkah ini wajib agar Firebase tidak mendeteksi objek lokal Dart dan mengosongkan field 'items'.
      final List<Map<String, dynamic>> cleanItemsForFirebase = [];
      for (var item in order.items) {
        if (item is Map) {
          cleanItemsForFirebase.add({
            'name': (item['name'] ?? '').toString(),
            'price': (item['price'] ?? 0) as int,
            'qty': (item['qty'] ?? 1) as int,
            'size': (item['size'] ?? '').toString(),
            'image': (item['image'] ?? '').toString(),
          });
        }
      }

      final orderData = {
        'id': order.id,
        'userId': order.userId,
        'userName': order.userName, 
        'userEmail': order.userEmail,
        'totalAmount': order.totalAmount,
        'status': order.status,
        'paymentMethod': order.paymentMethod,
        'address': order.address,
        'createdAt': Timestamp.fromDate(order.createdAt), 
        'items': cleanItemsForFirebase, // <--- Menggunakan list yang sudah steril murni JSON primitif
        'image': order.image,
        'paymentConfirmed': order.paymentConfirmed,
      };

      await _firestore
          .collection('orders') 
          .doc(order.id)
          .set(orderData);

      notifyListeners();
      await fetchOrders();
    } catch (e) {
      debugPrint("Add order error di Provider: $e");
      rethrow;
    }
  }

  /// =========================
  /// UPDATE STATUS
  /// =========================
  Future<void> updateStatus(String orderId, String status) async {
    try {
      if (orderId.trim().isEmpty) return;

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
      // FIX: Tanda petik disamakan menggunakan tunggal 'orders'
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
  /// GET USER ORDERS (HISTORY USER)
  /// =========================
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
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