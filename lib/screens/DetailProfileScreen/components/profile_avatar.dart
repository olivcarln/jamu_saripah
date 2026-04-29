import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final String? photoUrl;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.imageFile,
    required this.photoUrl,
    required this.onTap,
  });

  ImageProvider? _getImage() {
    if (imageFile != null) return FileImage(imageFile!);
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: const Color(0xFFEDEDED),
          backgroundImage: _getImage(),
          child: _getImage() == null
              ? const Icon(Icons.person, size: 40, color: Colors.grey)
              : null,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Color(0xFF7B8B5C),
            ),
          ),
        ),
      ],
    );
  }
}