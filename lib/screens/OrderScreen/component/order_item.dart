import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDone = order["status"] == "Selesai";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF7E8959).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_drink, color: Color(0xFF7E8959)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order["date"],
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rp ${order["price"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E8959),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDone
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order["status"],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDone ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}