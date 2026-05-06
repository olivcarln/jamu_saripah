class Product {
  final String name;
  final int price;
  final String size; 
  final String image;
  final String description;
  final int stock; // ✅ Field ini menyimpan data angka stok

  Product({
    required this.name, 
    required this.price, 
    required this.size, 
    required this.image, 
    required this.description, 
    required this.stock, // ✅ Wajib diisi di list produk
  });
}

List<Product> allProducts = [
  // 250 ML
  Product(
    name: "Wedang Jahe",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', 
    description: 'Minuman jahe hangat yang dibuat dari jahe emprit pilihan untuk meredakan tenggorokan dan menghangatkan tubuh.',
    stock: 12,
  ),
  Product(
    name: "Beras Kencur",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', 
    description: 'Perpaduan beras dan kencur berkualitas yang berkhasiat meningkatkan nafsu makan dan menghilangkan pegal-pegal.',
    stock: 3, // < 5 (Akan berwarna merah di UI)
  ),
  Product(
    name: "Kunyit Asem",
    price: 11776,
    size: "250 ml",
    image: 'assets/product(1).png', 
    description: 'Segarnya kunyit dan asam jawa asli yang kaya akan antioksidan, bagus untuk detoksifikasi tubuh.',
    stock: 20,
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: 62100,
    size: "250 ml x 5",
    image: 'assets/product(1).png', 
    description: 'Paket hemat isi 5 botol (Bisa mix varian). Cocok untuk persediaan sehat keluarga di rumah.',
    stock: 4, 
  ),

  // 350 ML
  Product(
    name: "Wedang Jahe",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', 
    description: 'Varian 350ml Wedang Jahe yang lebih puas untuk menemani aktivitas harian kamu agar tetap fit.',
    stock: 15,
  ),
  Product(
    name: "Beras Kencur",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', 
    description: 'Minuman tradisional beras kencur dalam kemasan medium, pas untuk menjaga stamina saat bekerja.',
    stock: 2, 
  ),
  Product(
    name: "Kunyit Asem",
    price: 18800,
    size: "350 ml",
    image: 'assets/product(1).png', 
    description: 'Kunyit asem segar dalam kemasan 350ml, rahasia alami untuk pencernaan yang lebih lancar.',
    stock: 25,
  ),
  Product(
    name: "Paket 3 Botol Wedang Jahe",
    price: 56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', 
    description: 'Triple kehangatan! Paket isi 3 botol Wedang Jahe 350ml untuk persediaan selama 3 hari.',
    stock: 10,
  ),
  Product(
    name: "Paket 3 Botol Beras Kencur",
    price: 56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', 
    description: 'Paket sehat isi 3 botol Beras Kencur 350ml, bantu jaga nafsu makan keluarga tetap stabil.',
    stock: 7,
  ),
  Product(
    name: "Paket 3 Botol Kunyit Asem",
    price: 56000,
    size: "350 ml x 3",
    image: 'assets/product(1).png', 
    description: 'Paket 3 botol Kunyit Asem 350ml, cara praktis untuk detoksifikasi rutin setiap minggu.',
    stock: 4, 
  ),
  Product(
    name: "Paket Mix 5 Botol",
    price: 94000,
    size: "350 ml x 5",
    image: 'assets/product(1).png', 
    description: 'Varian paket mix paling populer isi 5 botol. Bebas pilih varian favorit untuk stok di kantor.',
    stock: 6,
  ),

  // 1000 ML / 1 LITER
  Product(
    name: "Wedang Jahe",
    price: 49680,
    size: "1000 ml",
    image: 'assets/product(1).png', 
    description: 'Kemasan besar 1 Liter Wedang Jahe. Lebih ekonomis untuk dinikmati bersama seluruh anggota keluarga.',
    stock: 12,
  ),
  Product(
    name: "Beras Kencur",
    price: 49680,
    size: "1000 ml",
    image: 'assets/product(1).png', 
    description: 'Stok jumbo 1 Liter Beras Kencur. Simpan di kulkas dan nikmati kesegarannya kapan saja dibutuhkan.',
    stock: 5,
  ),
  Product(
    name: "Kunyit Asem",
    price: 49680,
    size: "1000 ml",
    image: 'assets/product(1).png', 
    description: 'Kunyit asem kemasan 1 Liter. Cara paling hemat untuk menjaga daya tahan tubuh seluruh penghuni rumah.',
    stock: 3, 
  ),
  Product(
    name: "Paket 2 Botol Wedang Jahe",
    price: 98900,
    size: "1000 ml x 2",
    image: 'assets/product(1).png', 
    description: 'Dua botol besar Wedang Jahe untuk kehangatan ekstra. Lebih hemat daripada beli satuan.',
    stock: 8,
  ),
  Product(
    name: "Paket 2 Botol Kunyit Asem",
    price: 98900,
    size: "1000 ml x 2",
    image: 'assets/product(1).png', 
    description: 'Dua botol besar Kunyit Asem. Pilihan cerdas untuk keluarga yang peduli pada kesehatan alami.',
    stock: 10,
  ), 
];