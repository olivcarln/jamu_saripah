import 'package:flutter/material.dart';
import 'package:jamu_saripah/screens/AccountScreen/Components/location_selection_screen.dart';

class AddressPicker extends StatelessWidget {
  final String selectedAddress;
  final Function(String) onSelect;

  const AddressPicker({
    super.key,
    required this.selectedAddress,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationSelectionScreen(),
            ),
          );

          if (result != null) {
            onSelect(result);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
               Icon(Icons.location_on, color: Color(0xFF7E8959)),
               SizedBox(width: 10),
              Expanded(
                child: Text(
                  selectedAddress,
                  style:  TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
               Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}