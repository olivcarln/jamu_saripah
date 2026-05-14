import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jamu_saripah/provider/auth_user_provider.dart';
import 'package:jamu_saripah/provider/order_provider.dart';

// TODO: REFACTORING - PERBAIKI KODE YANG REDUNDAN DAN OPTIMASI UI/UX ADMIN ORDER SCREEN
 
class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {
  /// FILTER
  String selectedFilter = "Semua";

  /// LIST STATUS VALID
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

  /// UPDATE STATUS
  Future<void> _updateStatus(
    BuildContext context,
    String orderId,
    String status,
  ) async {
    try {
      final orderProvider =
          Provider.of<OrderProvider>(
        context,
        listen: false,
      );

      await orderProvider.updateStatus(
        orderId,
        status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Status berhasil diubah menjadi $status",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Gagal update status: $e",
          ),
        ),
      );
    }
  }

  /// KONFIRMASI PEMBAYARAN
  Future<void> _confirmPayment(
    BuildContext context,
    String orderId,
  ) async {
    try {
      final orderProvider =
          Provider.of<OrderProvider>(
        context,
        listen: false,
      );

      await orderProvider.confirmPayment(
        orderId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Pembayaran berhasil dikonfirmasi",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Gagal konfirmasi pembayaran: $e",
          ),
        ),
      );
    }
  }

  /// FORMAT RUPIAH
  String formatRupiah(dynamic value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value ?? 0);
  }

  /// WARNA STATUS
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
    final authProvider =
        Provider.of<AuthUserProvider>(context);

    final String? emailLogin =
        authProvider.user?.email;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF9FAF7),

      body: Consumer<OrderProvider>(
        builder: (
          context,
          orderProvider,
          child,
        ) {
          /// AMBIL ORDER
          final allOrders =
              orderProvider.orders;

          /// FILTER
          final filteredOrders =
              selectedFilter == "Semua"
                  ? allOrders
                  : allOrders.where((
                      order,
                    ) {
                      switch (
                          selectedFilter) {
                        case "Diproses":
                          return order
                                  .status ==
                              "Diproses";

                        case "Sukses":
                          return order
                                  .status ==
                              "Sudah Diambil";

                        case "Dibatalkan":
                          return order
                                  .status ==
                              "Dibatalkan";

                        default:
                          return true;
                      }
                    }).toList();

          /// JIKA KOSONG
          if (filteredOrders.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada pesanan",
              ),
            );
          }

          return Column(
            children: [
              /// FILTER
              Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),

                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  decoration:
                      BoxDecoration(
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
                      value:
                          selectedFilter,

                      isExpanded: true,

                      items: const [
                        DropdownMenuItem(
                          value: "Semua",
                          child: Text(
                            "Semua Pesanan",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "Diproses",
                          child: Text(
                            "Sedang Diproses",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "Sukses",
                          child: Text(
                            "Pesanan Sukses",
                          ),
                        ),

                        DropdownMenuItem(
                          value:
                              "Dibatalkan",
                          child: Text(
                            "Pesanan Dibatalkan",
                          ),
                        ),
                      ],

                      onChanged: (
                        value,
                      ) {
                        if (value !=
                            null) {
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
                    ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  itemCount:
                      filteredOrders
                          .length,

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final order =
                        filteredOrders[
                            index];

                    final status =
                        orderStatuses.contains(
                              order
                                  .status,
                            )
                            ? order
                                .status
                            : orderStatuses
                                .first;

                    final isConfirmed =
                        order
                            .paymentConfirmed;

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
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
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
                                    const EdgeInsets.all(
                                  12,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: _statusColor(
                                    status,
                                  ).withOpacity(
                                    0.1,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    15,
                                  ),
                                ),

                                child:
                                    Icon(
                                  Icons
                                      .shopping_bag,

                                  color:
                                      _statusColor(
                                    status,
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
                                      CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      order
                                          .userName,

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            16,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          5,
                                    ),

                                    Text(
                                      order
                                              .email ??
                                          '-',

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.grey[600],

                                        fontSize:
                                            13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              _statusBadge(
                                status,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// TOTAL
                          Text(
                            "Total: ${formatRupiah(order.totalAmount)}",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// STATUS
                          Text(
                            "Status: ${order.status}",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// METODE
                          Text(
                            "Metode: ${order.method}",
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// =========================
                          /// MENU PESANAN
                          /// =========================
                          const Text(
                            "Menu Pesanan",
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize:
                                  15,
                            ),
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          ...(order.items ??
                                  [])
                              .map(
                            (item) {
                              if (item
                                  is Map) {
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
                                      const EdgeInsets.only(
                                    bottom:
                                        14,
                                  ),

                                  child:
                                      Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

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

                                                fit: BoxFit.cover,

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
                                                        Colors.grey[300],

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

                                                color:
                                                    Colors.grey[300],

                                                child:
                                                    const Icon(
                                                  Icons.image,
                                                ),
                                              ),
                                      ),

                                      const SizedBox(
                                        width:
                                            12,
                                      ),

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
                            },
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          /// UPDATE STATUS
                          DropdownButton<
                              String>(
                            value: status,

                            isExpanded:
                                true,

                            items:
                                orderStatuses.map((
                              item,
                            ) {
                              return DropdownMenuItem(
                                value:
                                    item,

                                child:
                                    Text(
                                  item,
                                ),
                              );
                            }).toList(),

                            onChanged:
                                (
                              value,
                            ) async {
                              if (value !=
                                  null) {
                                await _updateStatus(
                                  context,
                                  order.id,
                                  value,
                                );
                              }
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// KONFIRMASI
                          SizedBox(
                            width:
                                double.infinity,

                            child:
                                ElevatedButton(
                              onPressed:
                                  isConfirmed
                                      ? null
                                      : () async {
                                          await _confirmPayment(
                                            context,
                                            order.id,
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

                              child:
                                  Text(
                                isConfirmed
                                    ? "Sudah Konfirmasi"
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// BADGE STATUS
  Widget _statusBadge(
    String status,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: _statusColor(
          status,
        ).withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: _statusColor(status),

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}