import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final File? imageFile;
  final String? base64Image;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.imageFile,
    required this.base64Image,
    required this.onTap,
  });

  ImageProvider? _getImage() {

    // preview image baru
    if (imageFile != null) {
      return FileImage(imageFile!);
    }

    // image dari firestore
    if (base64Image != null &&
        base64Image!.isNotEmpty) {
      try {
        Uint8List bytes =
            base64Decode(base64Image!);

        return MemoryImage(bytes);
      } catch (e) {
        return null;
      }
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
              ? const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                )
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