import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    String productName,
    double price,
    String addedBy,
  ) {
    // Create a unique key combining product ID and user who added it
    final String cartItemKey = '$productId-$addedBy';

    if (_items.containsKey(cartItemKey)) {
      // Update existing item quantity for this specific user
      _items.update(
        cartItemKey,
        (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          productName: existingCartItem.productName,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          addedBy: existingCartItem.addedBy,
        ),
      );
    } else {
      // Add new item for this specific user
      _items.putIfAbsent(
        cartItemKey,
        () => CartItem(
          productId: productId,
          productName: productName,
          price: price,
          quantity: 1,
          addedBy: addedBy,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String cartItemKey) {
    _items.remove(cartItemKey);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
