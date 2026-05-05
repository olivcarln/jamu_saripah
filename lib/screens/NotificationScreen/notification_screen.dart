import 'package:flutter/material.dart';
import 'Components/filter_sheet.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = "Relevance"; // Simpan filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // Pakai tambahan dari Echa biar icon back-nya putih
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Pemberitahuan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:Color(0xFF7E8959),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              openFilterSheet(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/animation_notification.png',
              height: 200,
              color: const Color(0xFF7E8959),
            ),
            const SizedBox(height: 20),
            const Text(
              "Belum Ada Pemberitahuan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

    );
  }

  void openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return FilterSheet(
          onApply: (value) {
            setState(() {
              selectedFilter = value;
            });
          },
        );
      },
    );
  }
}