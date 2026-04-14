import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/NotificationScreen/Components/filter_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  String selectedFilter = ""; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Keranjang",
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
              'assets/cartShopping.svg',
              height: 200,
              color: Color(0xFF7E8959),
            ),
            SizedBox(height: 20),

            Text(
              "Keranjang Masih kosong",
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