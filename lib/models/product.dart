// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    String? imageUrl,
  }) : imageUrl = imageUrl ?? _generateImageUrl(id);

  // Static method to generate consistent image URLs based on product ID
  static String _generateImageUrl(String id) {
    // Use the product ID to create a consistent seed for the image
    // This ensures the same product always gets the same image
    final seed = id.hashCode % 1000; // Limit to 1000 different images
    return 'https://picsum.photos/seed/$seed/300/300'; // 300x300 images
  }
}
