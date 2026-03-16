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
        child: Stack(
          children: [

            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.push_pin,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}