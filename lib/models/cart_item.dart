class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String addedBy;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.addedBy,
  });

  /// Calculates the total price by multiplying the item's price by its quantity
  double get totalPrice => price * quantity;
}
