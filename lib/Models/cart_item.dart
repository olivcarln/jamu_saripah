class CartItem {
  final String id; // <--- Tambahkan ini
  final String name;
  final int price;
  final String image;
  final String size;
  int quantity;
  bool isChecked;

  CartItem({
    required this.id, // <--- Masukkan ke constructor
    required this.name,
    required this.price,
    required this.image,
    required this.size,
    this.quantity = 1,
    this.isChecked = true,
  });
}