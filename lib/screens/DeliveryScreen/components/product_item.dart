import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String name;
  final int price;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const ProductItem({
    super.key,
    required this.name,
    required this.price,
    required this.qty,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF7E8959),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_drink, color: Colors.white),
          ),

         SizedBox(width: 10),

          // INFO PRODUK
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp $price",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // QTY CONTROL
          Row(
            children: [
              // MINUS
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.remove, size: 16),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "$qty",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              // PLUS
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFF7E8959),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}