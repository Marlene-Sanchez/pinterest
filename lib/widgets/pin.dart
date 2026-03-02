import 'package:flutter/material.dart';

class PinGridItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const PinGridItem({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}