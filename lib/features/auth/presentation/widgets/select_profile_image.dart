// lib/features/auth/presentation/widgets/select_profile_image.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectProfileImage extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;

  const SelectProfileImage({
    super.key,
    required this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  width: 2,
                ),
                image: imagePath != null
                    ? DecorationImage(
                        image: FileImage(File(imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imagePath == null
                  ? Icon(
                      Icons.add_a_photo_outlined,
                      size: 32,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add Profile Photo',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
