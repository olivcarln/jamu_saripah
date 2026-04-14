import 'package:flutter/material.dart';
import 'package:jamu_saripah/common/constasts.dart';
import 'package:jamu_saripah/common/widgets/bottom_nav_bar.dart'; 
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputFieldGrey,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        centerTitle: false,
        title: const Text(
          "Pemberitahuan",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 118, 137, 88),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.tune, color: AppColors.white),
          )
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/animation_notification.png',
                height: 200,
                // Mengikuti warna tema utama
                color: AppColors.primaryOlive, 
              ),

              const SizedBox(height: 20),

              const Text(
                "Belum Ada Pemberitahuan",
                style: AppTextStyles.subHeading, 
              )
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNav(
        currentIndex: 2, 
        onTap: (index) {
      
        },
      ),
    );
  }
}