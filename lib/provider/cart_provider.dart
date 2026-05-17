import 'package:flutter/material.dart';
import '../Models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  bool _isAllChecked = false;

  /// DISKON VOUCHER
  double _voucherDiscount = 0;

  List<CartItem> get items => _items;

  List<Map<String, dynamic>> get cartItems {
    return _items
        .where((item) => item.isChecked)
        .map(
          (item) => {
            'name': item.name,
            'size': item.size,
            'price': item.price,
            'qty': item.quantity,
            'image': item.image,
          },
        )
        .toList();
  }

  bool get isAllChecked => _isAllChecked;

  /// GETTER DISKON
  double get voucherDiscount => _voucherDiscount;

  int get checkedItemsCount =>
      _items.where((item) => item.isChecked).length;

  /// SUBTOTAL
  int get checkedTotalPrice => _items
      .where((item) => item.isChecked)
      .fold(0, (sum, item) => sum + (item.price * item.quantity));

  /// TOTAL SETELAH DISKON
  double get totalPrice {
    double total = checkedTotalPrice - _voucherDiscount;

    if (total < 0) {
      total = 0;
    }

    return total;
  }

  /// TAMBAH KE CART
 void addToCart(CartItem newItem) {
  // Cek berdasarkan ID (lebih akurat daripada Nama)
  int index = _items.indexWhere((i) => i.id == newItem.id);

  if (index != -1) {
    // Kalau ID sama, tinggal tambah qty
    _items[index].quantity += newItem.quantity;
  } else {
    // Kalau ID beda, baru tambah baru
    newItem.isChecked = true;
    _items.add(newItem);
  }
  
  _isAllChecked = _items.every((item) => item.isChecked);
  notifyListeners();
}
  /// CHECK ITEM
  void checkItem(int index, bool value) {
    _items[index].isChecked = value;

    _isAllChecked =
        _items.isNotEmpty && _items.every((item) => item.isChecked);

    notifyListeners();
  }

  /// CHECK ALL
  void checkAll(bool value) {
    _isAllChecked = value;

    for (var item in _items) {
      item.isChecked = value;
    }

    notifyListeners();
  }

  /// TAMBAH QTY
  void incrementQuantity(int index) {
    _items[index].quantity++;

    notifyListeners();
  }

  /// KURANG QTY
  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;

      notifyListeners();
    }
  }

  /// HAPUS ITEM
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);

      if (_items.isEmpty) {
        _isAllChecked = false;
      }

      notifyListeners();
    }
  }

  /// CLEAR CART
  void clearCart() {
    _items.clear();

    _isAllChecked = false;

    _voucherDiscount = 0;

    notifyListeners();
  }

  /// HAPUS ITEM YANG DICHECKOUT (PILIH)
  void checkoutSelectedItems() {
    // Menghapus hanya item yang dicentang
    _items.removeWhere((item) => item.isChecked);

    // Update status checkbox global setelah sisa item berubah
    if (_items.isEmpty) {
      _isAllChecked = false;
      _voucherDiscount = 0; // Reset voucher jika keranjang benar-benar kosong
    } else {
      _isAllChecked = _items.every((item) => item.isChecked);
    }

    notifyListeners();
  }

  /// APPLY VOUCHER NOMINAL
  void applyVoucher(double amount) {
    _voucherDiscount = amount;

    notifyListeners();
  }

  /// APPLY VOUCHER PERSEN
  void applyVoucherPercent(double percent) {
    _voucherDiscount = checkedTotalPrice * (percent / 100);

    notifyListeners();
  }

  /// HAPUS VOUCHER
  void removeVoucher() {
    _voucherDiscount = 0;

    notifyListeners();
  }
}