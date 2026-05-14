import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/order.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onCancel;

  const OrderCard({super.key, required this.order, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (order.status.toLowerCase()) {
      case 'delivered':
      case 'sudah diambil':
        statusColor = Colors.green;
        break;

      case 'cancelled':
      case 'dibatalkan':
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],

        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
              /// HEADER
Align(
  alignment: Alignment.centerRight,

  child: Text(
    DateFormat('dd MMM yyyy').format(order.createdAt),

    style: TextStyle(
      color: Colors.grey[600],
      fontSize: 13,
    ),
  ),
),

                Text(
                  DateFormat('dd MMM yyyy').format(order.createdAt),

                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// STATUS
            Text(
              order.status.toUpperCase(),

              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 16),

            /// METODE
            Text(
              "Metode: ${order.method}",

              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),

            const SizedBox(height: 16),

            /// MENU PESANAN
            const Text(
              "Menu Pesanan",

              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            /// LIST MENU
            ...order.items.map<Widget>((item) {
              /// JIKA STRING
              if (item is String) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),

                  child: Text("• $item", style: const TextStyle(fontSize: 13)),
                );
              }

              /// JIKA MAP
              if (item is Map) {
                final String name = item['name']?.toString() ?? 'Menu';

                final String image = item['image']?.toString() ?? '';

                final int qty =
                    int.tryParse(item['qty']?.toString() ?? '0') ?? 0;

                final int price =
                    int.tryParse(item['price']?.toString() ?? '0') ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: image.isNotEmpty
                            ? Image.network(
                                image,

                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,

                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 55,
                                    height: 55,
                                    color: Colors.grey[200],

                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 55,
                                height: 55,
                                color: Colors.grey[200],

                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      const SizedBox(width: 12),

                      /// DETAIL
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            /// NAMA
                            Text(
                              name,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// JUMLAH
                            Text(
                              "Qty: $qty",

                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// HARGA
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(price),

                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.green,
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

            const SizedBox(height: 16),

            /// TOTAL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                /// TOTAL QTY
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Jumlah Item",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),

                    Text("${order.totalQty}"),
                  ],
                ),

                /// TOTAL HARGA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    const Text(
                      "Total Harga",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),

                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(order.totalAmount),

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// BUTTON BATALKAN
            if (order.status.toLowerCase() == 'order placed' ||
                order.status.toLowerCase() == 'pending' ||
                order.status.toLowerCase() == 'diproses')
              Padding(
                padding: const EdgeInsets.only(top: 16),

                child: Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,

                        builder: (context) => AlertDialog(
                          title: const Text("Batalkan Pesanan?"),

                          content: const Text(
                            "Apakah Anda yakin ingin membatalkan pesanan ini?",
                          ),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text("Tidak"),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                onCancel();
                              },

                              child: const Text(
                                "Ya, Batalkan",

                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                    style: TextButton.styleFrom(foregroundColor: Colors.red),

                    child: const Text("Batalkan Pesanan"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
