// lib/Provider/order_provider.dart

import 'package:flutter/material.dart';

class OrderModel {
  final String title;
  final String date;
  final int price;
  final String status;
  final String method;

  OrderModel({
    required this.title,
    required this.date,
    required this.price,
    required this.status,
    required this.method,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // order terbaru di atas
    notifyListeners();
  }
}