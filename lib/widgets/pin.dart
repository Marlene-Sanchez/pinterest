import 'package:flutter/material.dart';

class PinGridItem extends StatelessWidget {
  final VoidCallback onTap;

  const PinGridItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }
}