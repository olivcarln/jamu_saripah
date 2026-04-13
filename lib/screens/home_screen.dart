import 'package:flutter/material.dart';

class DummyHomeScreen extends StatelessWidget {
  const DummyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home (Dummy)"),
        backgroundColor: const Color(0xFF7E8959),
      ),
      body: const Center(
        child: Text(
          "Login berhasil 🎉",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}