import 'package:flutter/material.dart';
import '../Models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isAllChecked = false;
  double _discount = 0;

  List<CartItem> get items => _items;

  List<Map<String, dynamic>> get cartItems {
    return _items
        .where((item) => item.isChecked)
        .map((item) => {
              'name': item.name,
              'size': item.size,
              'price': item.price,
              'qty': item.quantity,
              'image': item.image,
            })
        .toList();
  }

  bool get isAllChecked => _isAllChecked;
  double get discount => _discount;

  int get checkedItemsCount =>
      _items.where((item) => item.isChecked).length;

  /// SUBTOTAL (Harga barang yang dicentang)
  int get checkedTotalPrice => _items
      .where((item) => item.isChecked)
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get totalPrice => checkedTotalPrice - _discount;

  // Baris "totalPoints" gue hapus dari sini karena poin sekarang
  // dihitung di OrderProvider setelah pesanan selesai.

  void addToCart(CartItem newItem) {
    int index = _items.indexWhere(
      (i) => i.name == newItem.name && i.size == newItem.size,
    );

    if (index != -1) {
      _items[index].quantity += newItem.quantity;
    } else {
      newItem.isChecked = true;
      _items.add(newItem);
    }

    _isAllChecked = _items.every((item) => item.isChecked);
    notifyListeners();
  }

  void checkItem(int index, bool value) {
    _items[index].isChecked = value;
    _isAllChecked =
        _items.isNotEmpty && _items.every((item) => item.isChecked);

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

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);

      if (_items.isEmpty) {
        _isAllChecked = false;
      }

      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _isAllChecked = false;
    _discount = 0;
    notifyListeners();
  }

  void applyVoucher(double amount) {
    _discount = amount;
    notifyListeners();
  }

  void applyVoucherPercent(double percent) {
    _discount = checkedTotalPrice * (percent / 100);
    notifyListeners();
  }

  void removeVoucher() {
    _discount = 0;
    notifyListeners();
  }
}