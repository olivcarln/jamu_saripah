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
  // 250 ML
  Product(
    name: "Wedang Jahe",
    price: "Rp 11.776",
    size: "250 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Beras Kencur",
    price: "Rp 11.776",
    size: "250 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Kunyit Asem",
    price: "Rp 11.776",
    size: "250 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: "Rp 62.100",
    size: "250 ml x 5",
    image: 'assets/product(1).png',
  ),

  // 350 ML
  Product(
    name: "Wedang Jahe",
    price: "Rp 18.800",
    size: "350 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Beras Kencur",
    price: "Rp 18.800",
    size: "350 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Kunyit Asem",
    price: "Rp 18.800",
    size: "350 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket 3 Botol Wedang Jahe",
    price: "Rp 56.000",
    size: "350 ml x 3",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket 3 Botol Beras Kencur",
    price: "Rp 56.000",
    size: "350 ml x 3",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket 3 Botol Kunyit Asem",
    price: "Rp 56.000",
    size: "350 ml x 3",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: "Rp 94.000",
    size: "350 ml x 5",
    image: 'assets/product(1).png',
  ),

  // 1000 ML / 1 LITER
  Product(
    name: "Wedang Jahe",
    price: "Rp 49.680",
    size: "1000 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Beras Kencur",
    price: "Rp 49.680",
    size: "1000 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Kunyit Asem",
    price: "Rp 49.680",
    size: "1000 ml",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket 2 Botol Wedang Jahe",
    price: "Rp 98.900",
    size: "1000 ml x 2",
    image: 'assets/product(1).png',
  ),
  Product(
    name: "Paket 2 Botol Kunyit Asem",
    price: "Rp 98.900",
    size: "1000 ml x 2",
    image: 'assets/product(1).png',
  ),
];
