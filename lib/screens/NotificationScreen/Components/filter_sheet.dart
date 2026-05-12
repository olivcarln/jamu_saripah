import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Function(Map<String, String>) onApply;

  const FilterSheet({super.key, required this.onApply});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String selectedHarga = "";
  String selectedKategori = "";
  String selectedJenis = "";

  void resetFilter() {
    setState(() {
      selectedHarga = "";
      selectedKategori = "";
      selectedJenis = "";
    });
  }

  void applyFilter() {
    widget.onApply({
      "harga": selectedHarga,
      "kategori": selectedKategori,
      "jenis": selectedJenis,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                const Text("Filter", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: resetFilter,
                  child: Text("Reset", style: TextStyle(color: Colors.grey[600])),
                ),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildFilterSection("Harga", ["Harga Tertinggi", "Harga Terendah"], selectedHarga, (val) => setState(() => selectedHarga = val)),
                    buildFilterSection("Kategori", ["250 ML", "350 ML", "1000 ML"], selectedKategori, (val) => setState(() => selectedKategori = val)),
                    buildFilterSection("Jenis Jamu", ["Beras Kencur", "Kunyit Asem", "Wedang Jahe"], selectedJenis, (val) => setState(() => selectedJenis = val)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF76895F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Apply Filter", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterSection(String title, List<String> options, String selectedValue, Function(String) onSelected) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: true,
        children: options.map((option) {
          final isSelected = selectedValue == option;
          return ListTile(
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF76895F) : Colors.grey,
            ),
            title: Text(option),
            onTap: () => onSelected(option),
          );
        }).toList(),
      ),
    );
  }
}