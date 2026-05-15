import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:jamu_saripah/provider/order_provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {
  String selectedFilter = "Semua";

  final List<String> orderStatuses = [
    "Diproses",
    "Menunggu Pengambilan",
    "Sudah Diambil",
    "Dibatalkan",
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<OrderProvider>(
        context,
        listen: false,
      ).fetchOrders();
    });
  }

  String formatRupiah(dynamic value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value ?? 0);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.blue;

      case 'Menunggu Pengambilan':
        return Colors.purple;

      case 'Sudah Diambil':
        return Colors.green;

      case 'Dibatalkan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF9FAF7),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF7E8959),

        title: const Text(
          "Admin Order",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

          /// FILTER
          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),

              child:
                  DropdownButtonHideUnderline(
                child:
                    DropdownButton<String>(
                  value: selectedFilter,
                  isExpanded: true,

                  items: const [

                    DropdownMenuItem(
                      value: "Semua",
                      child:
                          Text("Semua Pesanan"),
                    ),

                    DropdownMenuItem(
                      value: "Diproses",
                      child: Text(
                        "Sedang Diproses",
                      ),
                    ),

                    DropdownMenuItem(
                      value: "Sudah Diambil",
                      child:
                          Text("Pesanan Sukses"),
                    ),

                    DropdownMenuItem(
                      value: "Dibatalkan",
                      child: Text(
                        "Pesanan Dibatalkan",
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedFilter =
                            value;
                      });
                    }
                  },
                ),
              ),
            ),
          ),

          /// LIST ORDER
          Expanded(
            child:
                StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection('orders')
                  .orderBy(
                    'createdAt',
                    descending: true,
                  )
                  .snapshots(),

              builder:
                  (context, snapshot) {

                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          Color(0xFF7E8959),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                final docs =
                    snapshot.data?.docs ??
                        [];

                /// FILTER
                final filteredDocs =
                    selectedFilter ==
                            "Semua"
                        ? docs
                        : docs.where((doc) {

                            final data =
                                doc.data()
                                    as Map<
                                      String,
                                      dynamic
                                    >;

                            return (data['status'] ??
                                    '') ==
                                selectedFilter;
                          }).toList();

                if (filteredDocs
                    .isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada pesanan",
                    ),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                  ),

                  itemCount:
                      filteredDocs.length,

                  itemBuilder:
                      (context, index) {

                    final doc =
                        filteredDocs[index];

                    final data =
                        doc.data()
                            as Map<
                              String,
                              dynamic
                            >;

                    final orderId =
                        doc.id;

                    final String userName =
                        data['userName'] ??
                            'Customer';

                    final String userEmail =
                        data['userEmail'] ??
                            '-';

                    final int totalAmount =
                        data['totalAmount'] ??
                            0;

                    final String status =
                        data['status'] ??
                            'Diproses';

                    final String paymentMethod =
                        data['paymentMethod'] ??
                            '-';

                    final String address =
                        data['address'] ??
                            '-';

                    final bool paymentConfirmed =
                        data['paymentConfirmed'] ??
                            false;

                    final List items =
                        data['items'] ?? [];

                    final currentStatus =
                        orderStatuses
                                .contains(
                                  status,
                                )
                            ? status
                            : orderStatuses
                                .first;

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(
                              0.04,
                            ),

                            blurRadius: 10,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          /// HEADER
                          Row(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  12,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: _statusColor(
                                    currentStatus,
                                  ).withOpacity(
                                    0.1,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    15,
                                  ),
                                ),

                                child: Icon(
                                  Icons
                                      .shopping_bag,

                                  color:
                                      _statusColor(
                                    currentStatus,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      userName,

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            16,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      userEmail,

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .grey[600],

                                        fontSize:
                                            13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              _statusBadge(
                                currentStatus,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            "Total: ${formatRupiah(totalAmount)}",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Status: $status",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Metode: $paymentMethod",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "Alamat: $address",
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// ITEMS
                          if (items.isNotEmpty)
                            ...[
                              const Text(
                                "Menu Pesanan",

                                style: TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              ...items.map((item) {

                                if (item is Map) {

                                  final String name =
                                      item['name']
                                              ?.toString() ??
                                          'Menu';

                                  final String image =
                                      item['image']
                                              ?.toString() ??
                                          '';

                                  final int qty =
                                      int.tryParse(
                                            item['qty']
                                                .toString(),
                                          ) ??
                                          0;

                                  final int price =
                                      int.tryParse(
                                            item['price']
                                                .toString(),
                                          ) ??
                                          0;

                                  return Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 14,
                                    ),

                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        /// IMAGE
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                            10,
                                          ),

                                          child:
                                              image
                                                      .isNotEmpty
                                                  ? Image.network(
                                                      image,

                                                      width:
                                                          60,

                                                      height:
                                                          60,

                                                      fit:
                                                          BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width:
                                                          60,

                                                      height:
                                                          60,

                                                      color:
                                                          Colors.grey[
                                                              300],

                                                      child:
                                                          const Icon(
                                                        Icons.image,
                                                      ),
                                                    ),
                                        ),

                                        const SizedBox(
                                          width: 12,
                                        ),

                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,

                                            children: [

                                              Text(
                                                name,

                                                style:
                                                    const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,

                                                  fontSize:
                                                      14,
                                                ),
                                              ),

                                              const SizedBox(
                                                height:
                                                    4,
                                              ),

                                              Text(
                                                "Qty: $qty",
                                              ),

                                              const SizedBox(
                                                height:
                                                    4,
                                              ),

                                              Text(
                                                formatRupiah(
                                                  price,
                                                ),

                                                style:
                                                    const TextStyle(
                                                  color:
                                                      Colors.green,

                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return const SizedBox();
                              }).toList(),
                            ],

                          const SizedBox(
                            height: 10,
                          ),

                          /// UPDATE STATUS
                          DropdownButton<String>(
                            value:
                                currentStatus,

                            isExpanded: true,

                            items:
                                orderStatuses.map((
                              item,
                            ) {
                              return DropdownMenuItem(
                                value: item,
                                child:
                                    Text(item),
                              );
                            }).toList(),

                            onChanged:
                                (value) async {

                              if (value != null) {

                                await Provider.of<
                                    OrderProvider>(
                                  context,
                                  listen: false,
                                ).updateStatus(
                                  orderId,
                                  value,
                                );
                              }
                            },
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          /// KONFIRMASI
                          SizedBox(
                            width:
                                double.infinity,

                            child:
                                ElevatedButton(
                              onPressed:
                                  paymentConfirmed
                                      ? null
                                      : () async {

                                          await Provider.of<
                                              OrderProvider>(
                                            context,
                                            listen:
                                                false,
                                          ).confirmPayment(
                                            orderId,
                                          );
                                        },

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFF7E8959,
                                ),

                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical:
                                      14,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),
                              ),

                              child: Text(
                                paymentConfirmed
                                    ? "Sudah Dikonfirmasi"
                                    : "Konfirmasi Pembayaran",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: _statusColor(status)
            .withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}