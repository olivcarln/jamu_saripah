class Product {
  final String name;
  final String price;
  final String size; // Tambahan untuk ukuran (misal: 250ml)
  final String image;

  Product({
    required this.name, 
    required this.price, 
    required this.size, 
    required this.image,
  });
}

List<Product> allProducts = [
  Product(
    name: "Kunyit Asam",
    price: "Rp 15.000",
    size: "250 ml",
    image: 'assets/product(1).png'
  ),
  Product(
    name: "Beras Kencur",
    price: "Rp 12.000",
    size: "250 ml",
    image: 'assets/product(1).png'
  ),
  Product(
    name: "Temulawak",
    price: "Rp 18.000",
    size: "500 ml",
    image: 'assets/product(1).png'
  ),
  Product(
    name: "Gula Asam",
    price: "Rp 10.000",
    size: "250 ml",
    image: 'assets/product(1).png'
  ),
  Product(
    name: "Jahe Merah",
    price: "Rp 20.000",
    size: "250 ml",
    image: 'assets/product(1).png'
  ),
  Product(
    name: "Sari Rapet",
    price: "Rp 25.000",
    size: "150 ml",
  image: 'assets/product(1).png'
  ),
];
