import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamu_saripah/Models/order.dart';
import 'package:jamu_saripah/common/constasts.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onCancel;

  const OrderCard({super.key, required this.order, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final status = order.status.trim();
    Color statusColor;

    switch (status) {
      case 'Sudah Diambil':
        statusColor = Colors.green;
        break;
      case 'Dibatalkan':
        statusColor = Colors.red;
        break;
      case 'Menunggu Pengambilan':
        statusColor = Colors.purple;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =================================
          /// HEADER (IMAGE + DETAIL USER/OUTLET)
          /// =================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    order.items.isNotEmpty &&
                        order.items.first is Map &&
                        order.items.first['image'] != null
                    ? (() {
                        final image = order.items.first['image'].toString();
                        if (image.startsWith('http')) {
                          return Image.network(
                            image,
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                          );
                        }
                        if (image.startsWith('assets')) {
                          return Image.asset(
                            image,
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                          );
                        }
                        return Image.memory(
                          base64Decode(image),
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        );
                      })()
                    : Container(
                        width: 82,
                        height: 82,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
              ),
              const SizedBox(width: 14),

              /// DETAIL INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAMA USER (Ganti bagian ini aja biar dinamis motong dari email kalau datanya "User")
                    Text(
                      order.userName == "User" &&
                              order.userEmail != null &&
                              order.userEmail!.contains('@')
                          ? order.userEmail!.split('@')[0]
                          : order.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    /// EMAIL USER
                    Text(
                      order.userEmail ?? "No Email",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 6),

                    /// OUTLET / ALAMAT
                    Text(
                      order.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.primaryOlive,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// DATE + STATUS
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(order.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "•",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// DAFTAR MENU SINGKAT
          Text(
            order.items
                .take(2)
                .map((item) {
                  if (item is Map) return "${item['qty']} ${item['name']}";
                  return item.toString();
                })
                .join(", "),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 12),

          /// =================================
          /// TOTAL + REORDER BUTTON
          /// =================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(order.totalAmount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${order.items.length} menu",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  // Tambahkan logika reorder di sini
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOlive,
                  side: const BorderSide(color: AppColors.primaryOlive),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text(
                  "Reorder",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          /// =================================
          /// STATUS SPECIFIC INFO (BANNER)
          /// =================================
          if (status == 'Diproses')
            _buildStatusBanner(
              Icons.info_outline,
              Colors.orange,
              "Pesanan sedang diproses dan tidak dapat dibatalkan.",
            ),

          if (status == 'Menunggu Pengambilan')
            _buildStatusBanner(
              Icons.store_mall_directory_outlined,
              Colors.purple,
              "Pesanan siap diambil di outlet.",
            ),

          if (status == 'Sudah Diambil') _buildRatingSection(),
        ],
      ),
    );
  }

  /// Helper untuk banner status
  Widget _buildStatusBanner(IconData icon, Color color, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper untuk section rating
  Widget _buildRatingSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rate your order",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (index) =>
                  Icon(Icons.star_rounded, color: Colors.grey[300], size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
