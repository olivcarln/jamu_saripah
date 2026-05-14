import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userName;
  final int totalAmount;
  final String status;
  final String method;
  final String email;
  final String address;
  final bool paymentConfirmed;
  final DateTime createdAt;

  /// SUPPORT DATA LAMA + BARU
  final List<dynamic> items;

  OrderModel({
    required this.id,
    required this.userName,
    required this.totalAmount,
    required this.status,
    required this.method,
    required this.createdAt,
    required this.items,
    this.email = '',
    this.address = '',
    this.paymentConfirmed = false,
  });

  /// JUMLAH JENIS ITEM
  int get itemCount => items.length;

  /// TOTAL QTY SEMUA ITEM
  int get totalQty {
    int total = 0;

    for (var item in items) {

      /// JIKA FORMAT BARU (MAP)
      if (item is Map) {

        total += int.tryParse(
              item['qty']?.toString() ?? '0',
            ) ??
            0;
      }

      /// JIKA FORMAT LAMA (STRING)
      else {
        total += 1;
      }
    }

    return total;
  }

  /// FROM FIRESTORE
  factory OrderModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: doc.id,

      /// USER NAME
      userName:
          data['userName']?.toString() ??
              'Customer',

      /// TOTAL PRICE
      totalAmount:
          (data['totalPrice'] ??
                      data['price'] ??
                      0)
                  is int
              ? (data['totalPrice'] ??
                  data['price'] ??
                  0)
              : int.tryParse(
                    (data['totalPrice'] ??
                            data['price'] ??
                            '0')
                        .toString(),
                  ) ??
                  0,

      /// STATUS
      status:
          data['status']?.toString() ??
              'Pending',

      /// PAYMENT METHOD
      method:
          data['paymentMethod']
                  ?.toString() ??
              'Delivery',

      /// EMAIL
      email:
          data['userEmail']
                  ?.toString() ??
              '',

      /// ADDRESS
      address:
          data['address']
                  ?.toString() ??
              '',

      /// PAYMENT
      paymentConfirmed:
          data['paymentConfirmed'] ??
              false,

      /// ITEMS
      items:
          data['items'] is List
              ? List<dynamic>.from(
                  data['items'],
                )
              : [],

      /// CREATED AT
      createdAt:
          data['createdAt']
                  is Timestamp
              ? (data['createdAt']
                      as Timestamp)
                  .toDate()
              : DateTime.now(),
    );
  }

  /// TO MAP
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'totalPrice': totalAmount,
      'status': status,
      'paymentMethod': method,
      'userEmail': email,
      'address': address,
      'paymentConfirmed':
          paymentConfirmed,
      'items': items,
      'createdAt':
          Timestamp.fromDate(createdAt),
    };
  }

  /// COPY WITH
  OrderModel copyWith({
    String? id,
    String? userName,
    int? totalAmount,
    String? status,
    String? method,
    String? email,
    String? address,
    bool? paymentConfirmed,
    DateTime? createdAt,
    List<dynamic>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,

      userName:
          userName ?? this.userName,

      totalAmount:
          totalAmount ??
              this.totalAmount,

      status:
          status ?? this.status,

      method:
          method ?? this.method,

      email:
          email ?? this.email,

      address:
          address ?? this.address,

      paymentConfirmed:
          paymentConfirmed ??
              this.paymentConfirmed,

      createdAt:
          createdAt ??
              this.createdAt,

      items:
          items ?? this.items,
    );
  }
}