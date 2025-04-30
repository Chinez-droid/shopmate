class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String addedBy; // Track who added this item

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.addedBy,
  });

  double get totalPrice => price * quantity;
}
