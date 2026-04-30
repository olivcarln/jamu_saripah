class CartItem {
  final String name;
  final String image;
  final String size;
  final int price;    // ✅ Harus int
  int quantity;       // ✅ Harus int
  bool isChecked;

  CartItem({
    required this.name,
    required this.image,
    required this.size,
    required this.price,
    this.quantity = 1,
    this.isChecked = false,
  });
}