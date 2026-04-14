import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Function(String) onApply;

  const FilterSheet({super.key, required this.onApply});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String selectedSort = "Relevance";

  void resetFilter() {
    setState(() {
      selectedSort = "Relevance";
    });
  }

  void applyFilter() {
    widget.onApply(selectedSort);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(16),
      child: SafeArea( // 🔥 biar ga ketiban notch / navbar
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Filters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: resetFilter,
                  child: Text("Reset",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600]
                  ),
                  ),
                )
              ],
            ),

             SizedBox(height: 10),

            /// SORT
             Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Sort by",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

           SizedBox(height: 8),

            buildRadio("Relevance"),
            buildRadio("Most recent"),
            buildRadio("Highest priced"),
            buildRadio("Lowest priced"),

          SizedBox(height: 20),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text("Show results",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                ),
              
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRadio(String value) {
    final isSelected = selectedSort == value;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(value),
      trailing: Icon(
        isSelected
            ? Icons.radio_button_checked
            : Icons.radio_button_off,
        color: isSelected ? Colors.black : Colors.grey,
      ),
      onTap: () {
        setState(() {
          selectedSort = value;
        });
      },
    );
  }
}