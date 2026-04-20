import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final int price;
  final int quantity;
  final String image;

  CartItem({required this.name, required this.price, required this.quantity, required this.image});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addToCart(CartItem item) {
    _items.add(item);
    notifyListeners(); // Ini yang bikin halaman lain tau ada barang masuk
  }
}