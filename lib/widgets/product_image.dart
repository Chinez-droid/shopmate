// lib/widgets/product_image.dart
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const ProductImage({
    required this.imageUrl,
    this.height = 150,
    this.width = 150,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 50,
            ),
          );
        },
      ),
    );
  }
}