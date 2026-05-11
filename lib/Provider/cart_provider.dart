import 'package:flutter/material.dart';
import '../Models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isAllChecked = false;

  List<CartItem> get items => _items;
  bool get isAllChecked => _isAllChecked;

  int get checkedItemsCount => _items.where((item) => item.isChecked).length;

  int get checkedTotalPrice => _items
      .where((item) => item.isChecked)
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  int get totalPoints => (checkedTotalPrice / 100).floor();    

  void addToCart(CartItem newItem) {
    int index = _items.indexWhere((i) => i.name == newItem.name && i.size == newItem.size);

    if (index != -1) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void checkItem(int index, bool value) {
    _items[index].isChecked = value;
    _isAllChecked = _items.isNotEmpty && _items.every((item) => item.isChecked);
    notifyListeners();
  }

  void checkAll(bool value) {
    _isAllChecked = value;
    for (var item in _items) {
      item.isChecked = value;
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  // 1. Fungsi buat hapus satu item (Dipake di Dismissible/Geser)
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      // Update status "Pilih Semua" kalau list jadi kosong
      if (_items.isEmpty) _isAllChecked = false;
      notifyListeners();
    }
  }

  // 2. Fungsi buat kosongin keranjang (Dipake di Pop-up Lu)
  void clearCart() {
    _items.clear();
    _isAllChecked = false;
    notifyListeners();
  }
}