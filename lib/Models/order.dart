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

  /// TOTAL ITEM
  int get totalItem {
    int total = 0;

    for (var item in items) {
      total += (item['qty'] ?? 0) as int;
    }

    return total;
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,

      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',

      totalAmount: data['totalAmount'] ?? 0,

      status: data['status'] ?? '',

      paymentMethod: data['paymentMethod'] ?? '',

      address: data['address'] ?? '',

      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),

      items: data['items'] ?? [],

      image: data['image'] ?? '',

      paymentConfirmed:
          data['paymentConfirmed'] ?? false,
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