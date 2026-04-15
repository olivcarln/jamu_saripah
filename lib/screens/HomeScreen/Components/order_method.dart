import 'package:flutter/material.dart';

class OrderMethod extends StatelessWidget {
  final String userName;
  final VoidCallback onPickUpTap;
  final VoidCallback onDeliveryTap;

  const OrderMethod({
    super.key,
    required this.userName,
    required this.onPickUpTap,
    required this.onDeliveryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi $userName, Ready to Order?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              _buildMethodCard(
                title: "Pick Up",
                subtitle: "Ambil sendiri pesananmu di outlet terdekat.",
                imagePath: "assets/pickup.png",
                onTap: onPickUpTap,
              ),
               SizedBox(width: 15),
              _buildMethodCard(
                title: "Delivery",
                subtitle: "Jamu segar akan kami antar ke depan pintumu.",
                imagePath: "assets/delivery.png",
                onTap: onDeliveryTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 135,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E6D45),
                  ),
                ),
                 SizedBox(height: 4),
                SizedBox(
                  width: 85, 
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 9, color: Colors.black54),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}