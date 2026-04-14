import 'package:flutter/material.dart';
import 'Components/filter_sheet.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  String selectedFilter = "Relevance"; // simpan filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Pemberitahuan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF7E8959),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
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
              color: Color(0xFF7E8959),
            ),

            SizedBox(height: 20),

            Text(
              "Belum Ada Pemberitahuan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

      
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Color(0xFF7E8959),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Vouchers"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Your order"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }

  void openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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