import 'package:flutter/material.dart';
import 'package:jamu_saripah/Models/order_model.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/provider/order_provider.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();

    /// FETCH ORDER DARI FIRESTORE
    Future.microtask(() {
      Provider.of<OrderProvider>(
        context,
        listen: false,
      ).fetchOrders();
    });
  }

  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;

      case 'Diproses':
        return Colors.blue;

      case 'Menunggu Pengambilan':
        return Colors.deepPurple;

      case 'Selesai':
        return Colors.green;

      case 'Dibatalkan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider =
        Provider.of<OrderProvider>(context);

    final List<OrderModel> orders =
        orderProvider.orders;

    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        title: const Text(
          "Riwayat Pesanan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryOlive,
      ),

      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 90,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Belum ada pesanan",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<OrderProvider>(
                  context,
                  listen: false,
                ).fetchOrders();
              },

              child: ListView.builder(
                padding:
                    const EdgeInsets.all(16),

                itemCount: orders.length,

                itemBuilder: (
                  context,
                  index,
                ) {
                  final order =
                      orders[index];

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),

                    elevation: 3,

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          /// =========================
                          /// HEADER
                          /// =========================
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [
                              Expanded(
                                child: Text(
                                  order.userName,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize:
                                        18,
                                  ),
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal:
                                      10,
                                  vertical:
                                      4,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: getStatusColor(
                                          order
                                              .status)
                                      .withOpacity(
                                          0.15),

                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),
                                ),

                                child: Text(
                                  order.status,
                                  style:
                                      TextStyle(
                                    fontSize:
                                        12,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        getStatusColor(
                                      order
                                          .status,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 8),

                          /// METHOD
                          Row(
                            children: [
                              Icon(
                                order.method ==
                                        'Delivery'
                                    ? Icons
                                        .delivery_dining
                                    : Icons
                                        .store,

                                size: 18,

                                color:
                                    Colors.grey,
                              ),

                              const SizedBox(
                                  width: 6),

                              Text(
                                order.method,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 16),

                          /// =========================
                          /// TITLE MENU
                          /// =========================
                          const Text(
                            "Menu Pesanan",
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(
                              height: 12),

                          /// =========================
                          /// ITEMS
                          /// =========================
                          ...(order.items ?? [])
                              .map((item) {
                            /// FORMAT STRING LAMA
                            if (item is String) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 8,
                                ),

                                child: Text(
                                    "• $item"),
                              );
                            }

                            /// FORMAT MAP BARU
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
                                        item[
                                                'price']
                                            .toString(),
                                      ) ??
                                      0;

                              return Padding(
                                padding:
                                    const EdgeInsets.only(
                                  bottom: 12,
                                ),

                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    /// IMAGE
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                        10,
                                      ),

                                      child: image
                                              .isNotEmpty
                                          ? Image.network(
                                              image,
                                              width:
                                                  60,
                                              height:
                                                  60,
                                              fit: BoxFit
                                                  .cover,

                                              errorBuilder:
                                                  (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
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
                                                );
                                              },
                                            )
                                          : Container(
                                              width:
                                                  60,
                                              height:
                                                  60,
                                              decoration:
                                                  BoxDecoration(
                                                color:
                                                    Colors.grey[300],

                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),

                                              child:
                                                  const Icon(
                                                Icons
                                                    .image,
                                              ),
                                            ),
                                    ),

                                    const SizedBox(
                                        width: 12),

                                    /// DETAIL
                                    Expanded(
                                      child:
                                          Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

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
                                                  4),

                                          Text(
                                            "Qty: $qty",
                                          ),

                                          const SizedBox(
                                              height:
                                                  4),

                                          Text(
                                            "Rp ${formatHarga(price)}",

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

                          const Divider(
                              height: 24),

                          /// =========================
                          /// TOTAL
                          /// =========================
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [
                              const Text(
                                "Total Pembayaran",
                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              Text(
                                "Rp ${formatHarga(order.totalAmount)}",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.green,

                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  fontSize:
                                      16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}