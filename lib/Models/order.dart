import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;

  final String userId;
  final String userName;
  final String userEmail;

  final int totalAmount;

  final String status;
  final String paymentMethod;
  final String address;

  final DateTime createdAt;

  final List<dynamic> items;

  final String image;

  final bool paymentConfirmed;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
    required this.items,
    required this.image,
    required this.paymentConfirmed,
  });

  /// TOTAL ITEM (Tetap Utuh Bawaan Lu)
  int get totalItem {
    int total = 0;

    for (var item in items) {
      // Ditambahkan safety check dikit biar ga crash kalau itemnya ternyata bertipe objek kelas
      if (item is Map) {
        total += (item['qty'] ?? 0) as int;
      } else {
        try {
          total += (item.qty ?? 0) as int;
        } catch (_) {}
      }
    }

    return total;
  }

  /// FACTORY FROMFIRESTORE (ANTI-CRASH)
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Penjinak konversi tanggal createdAt agar tidak crash tipe data String / Timestamp / Null
    DateTime parsedDate = DateTime.now();
    // Cek field 'createdAt' atau cadangan 'created_at'
    var rawDate = data['createdAt'] ?? data['created_at'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    }

    return OrderModel(
      id: doc.id,

      userId: data['userId'] ?? '',
      userName: data['userName'] ?? data['customerName'] ?? '',
      userEmail: data['userEmail'] ?? data['email'] ?? '',

      // Menampung 'totalAmount' baru atau 'totalPrice' dari data lama biar ga Rp 0
      totalAmount: (data['totalAmount'] ?? data['totalPrice'] ?? 0) as int,

      status: data['status'] ?? '',

      paymentMethod: data['paymentMethod'] ?? '',

      address: data['address'] ?? '',

      createdAt: parsedDate,

      items: data['items'] is List ? data['items'] as List : [],

      image: data['image'] ?? '',

      paymentConfirmed: data['paymentConfirmed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,

      'totalAmount': totalAmount,

      'status': status,

      'paymentMethod': paymentMethod,

      'address': address,

      'createdAt': Timestamp.fromDate(createdAt),

      'items': items,

      'image': image,

      'paymentConfirmed': paymentConfirmed,
    };
  }

  // COPY WITH (Tetap Utuh Sesuai Parameter Asli Lu)
  OrderModel copyWith({
    String? status,
    bool? paymentConfirmed,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      totalAmount: totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      address: address,
      createdAt: createdAt,
      items: items,
      image: image,
      paymentConfirmed:
          paymentConfirmed ?? this.paymentConfirmed,
    );
  }
}