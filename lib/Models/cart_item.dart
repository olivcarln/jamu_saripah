class CartItem {
  final String name;
  final String size;
  final int price;
  final String image;
  bool isChecked;
  int quantity; // <--- Tambahin ini

  CartItem({
    required this.name,
    required this.size,
    required this.price,
    required this.image,
    this.isChecked = false,
    this.quantity = 1, // <--- Default beli 1
  });
}