import 'package:flutter/material.dart';
import '../Models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isAllChecked = false;

  List<CartItem> get items => _items;
  bool get isAllChecked => _isAllChecked;

  // ✅ Hitung jumlah item yang dicentang
  int get checkedItemsCount => _items.where((item) => item.isChecked).length;

  // ✅ Hitung total harga item yang dicentang saja
  int get checkedTotalPrice => _items
      .where((item) => item.isChecked)
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  // ✅ FUNGSI UTAMA: Tambah ke Keranjang (Biar Error di Detail Screen Ilang)
  void addToCart(CartItem newItem) {
    // Cek apakah produk dengan nama & ukuran yang sama udah ada
    int index = _items.indexWhere((i) => i.name == newItem.name && i.size == newItem.size);

    if (index != -1) {
      // Kalau udah ada, tinggal tambahin quantity-nya
      _items[index].quantity += newItem.quantity;
    } else {
      // Kalau belum ada, masukin sebagai item baru
      _items.add(newItem);
    }
    notifyListeners(); // Update UI di semua screen
  }

  // ✅ Logic Checkbox Per Item
  void checkItem(int index, bool value) {
    _items[index].isChecked = value;
    // Update status "Pilih Semua" otomatis
    _isAllChecked = _items.every((item) => item.isChecked);
    notifyListeners();
  }

  // ✅ Logic Pilih Semua
  void checkAll(bool value) {
    _isAllChecked = value;
    for (var item in _items) {
      item.isChecked = value;
    }
    notifyListeners();
  }

  // ✅ Logic Tambah Quantity di Cart
  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // ✅ Logic Kurang Quantity di Cart
  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }
}