class CartItem {
  final String name;
  final String image;
  final String size;
  final int price;
  int quantity;
  bool isChecked; // ✅ WAJIB ADA INI

  CartItem({
    required this.name,
    required this.image,
    required this.size,
    required this.price,
    this.quantity = 1,
    this.isChecked = false, // Default awal gak dicentang
  });
}