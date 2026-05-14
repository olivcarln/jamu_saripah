import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userName;
  final int totalAmount;
  final String status;

  final String paymentMethod;

  final String address;

  final bool paymentConfirmed;

  final DateTime createdAt;

  final List<dynamic> items;

  final String image;

  final String? userEmail;

  final String? notes;

  OrderModel({
    required this.id,
    required this.userName,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.address,
    required this.paymentConfirmed,
    required this.createdAt,
    required this.items,
    required this.image,
    this.userEmail,
    this.notes,
  });

  /// FROM FIRESTORE
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,

      userName: json['user_name']?.toString() ?? 'Customer',

      totalAmount: json['total_amount'] is int
          ? json['total_amount']
          : int.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,

      status: json['status']?.toString() ?? 'Pending',

      paymentMethod: json['payment_method']?.toString() ?? 'COD',

      address: json['address']?.toString() ?? '',

      paymentConfirmed: json['payment_confirmed'] ?? false,

      image: json['image']?.toString() ?? '',

      createdAt: json['created_at'] is Timestamp
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.parse(
              json['created_at']?.toString() ?? DateTime.now().toString(),
            ),

      items: json['items'] is List ? List<dynamic>.from(json['items']) : [],

      userEmail: json['user_email'] as String?,

      notes: json['notes'] as String?,
    );
  }

  /// FROM FIRESTORE DOCUMENT
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel.fromJson({...data, 'id': doc.id});
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'user_name': userName,

      'total_amount': totalAmount,

      'status': status,

      'payment_method': paymentMethod,

      'address': address,

      'payment_confirmed': paymentConfirmed,

      'created_at': Timestamp.fromDate(createdAt),

      'items': items,

      'image': image,

      'user_email': userEmail,

      'notes': notes,
    };
  }

  /// TOTAL ITEM
  int get totalItem {
    int total = 0;

    for (var item in items) {
      if (item is Map) {
        total += int.tryParse(item['qty']?.toString() ?? '0') ?? 0;
      } else {
        total += 1;
      }
    }

    return total;
  }

  /// COPY WITH
  OrderModel copyWith({
    String? id,
    String? userName,
    int? totalAmount,
    String? status,
    String? paymentMethod,
    String? address,
    bool? paymentConfirmed,
    DateTime? createdAt,
    List<dynamic>? items,
    String? image,
    String? userEmail,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,

      userName: userName ?? this.userName,

      totalAmount: totalAmount ?? this.totalAmount,

      status: status ?? this.status,

      paymentMethod: paymentMethod ?? this.paymentMethod,

      address: address ?? this.address,

      paymentConfirmed: paymentConfirmed ?? this.paymentConfirmed,

      createdAt: createdAt ?? this.createdAt,

      items: items ?? this.items,

      image: image ?? this.image,

      userEmail: userEmail ?? this.userEmail,

      notes: notes ?? this.notes,
    );
  }
}
