class Product {
  final String name;
  final int price;
  final String size; // Tambahan untuk ukuran (misal: 250ml)
  final String image;
  final String description;

  Product({
    required this.name, 
    required this.price, 
    required this.size, 
    required this.image, required this.description,
  });
}

List<Product> allProducts = [
  // 250 ML
  Product(
    name: "Wedang Jahe",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Beras Kencur",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Kunyit Asem",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: 62100,
    size: "250 ml x 5",
    image: 'assets/product(1).png', description: '',
  ),

  // 350 ML
  Product(
    name: "Wedang Jahe",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Beras Kencur",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Kunyit Asem",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket 3 Botol Wedang Jahe",
    price:  56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket 3 Botol Beras Kencur",
    price:  56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket 3 Botol Kunyit Asem",
    price:  56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: 94000,
    size: "350 ml x 5",
    image: 'assets/product(1).png', description: '',
  ),

  // 1000 ML / 1 LITER
  Product(
    name: "Wedang Jahe",
    price: 49680,
    size: "1000 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Beras Kencur",
    price: 49680,
    size: "1000 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Kunyit Asem",
    price:  49680,
    size: "1000 ml",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket 2 Botol Wedang Jahe",
    price: 98900,
    size: "1000 ml x 2",
    image: 'assets/product(1).png', description: '',
  ),
  Product(
    name: "Paket 2 Botol Kunyit Asem",
    price: 98900,
    size: "1000 ml x 2",
    image: 'assets/product(1).png', description: '',
  ),
];