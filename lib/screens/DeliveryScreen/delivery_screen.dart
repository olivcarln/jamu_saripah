import 'package:flutter/material.dart';
import 'components/delivery_header.dart';
import 'components/address_picker.dart';
import 'components/product_list.dart';
import 'components/checkout_button.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  String selectedAddress = "Pilih alamat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          DeliveryHeader(
            onBack: () => Navigator.pop(context),
          ),

          AddressPicker(
            selectedAddress: selectedAddress,
            onSelect: (value) {
              setState(() {
                selectedAddress = value;
              });
            },
          ),

          Expanded(child: ProductList()),

          CheckoutButton(),
        ],
      ),
    );
  }
}