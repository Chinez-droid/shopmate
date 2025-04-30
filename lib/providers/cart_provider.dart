import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/firestore_service.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final FirestoreService _firestoreService = FirestoreService();
  String _sessionId = '';
  StreamSubscription<Map<String, CartItem>>? _cartSubscription;

  CartProvider();

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

  String get sessionId => _sessionId;

  // Set active session ID and listen for cart updates
  void setActiveSession(String sessionId) {
    _sessionId = sessionId;

    // Cancel any existing subscription
    _cartSubscription?.cancel();

    // Start listening to cart changes if we have a valid session ID
    if (sessionId.isNotEmpty) {
      _cartSubscription = _firestoreService.getCartItems(sessionId).listen((
        cartItems,
      ) {
        _items = cartItems;
        notifyListeners();
      });
    }
  }

  // Add item to cart
  Future<void> addItem(
    String productId,
    String productName,
    double price,
    String addedBy,
  ) async {
    if (_sessionId.isEmpty) {
      throw Exception('No active session');
    }

    // Create a unique key combining product ID and user who added it
    final String cartItemKey = '$productId-$addedBy';

    try {
      if (_items.containsKey(cartItemKey)) {
        // Update existing item quantity for this specific user
        final existingItem = _items[cartItemKey]!;
        final updatedItem = CartItem(
          productId: existingItem.productId,
          productName: existingItem.productName,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
          addedBy: existingItem.addedBy,
        );

        await _firestoreService.addItemToCart(
          _sessionId,
          cartItemKey,
          updatedItem,
        );
      } else {
        // Add new item for this specific user
        final newItem = CartItem(
          productId: productId,
          productName: productName,
          price: price,
          quantity: 1,
          addedBy: addedBy,
        );

        await _firestoreService.addItemToCart(_sessionId, cartItemKey, newItem);
      }
    } catch (error) {
      debugPrint('Error adding item to cart: $error');
      throw Exception('Failed to add item to cart');
    }
  }

  // Update item quantity directly
  Future<void> updateItemQuantity(String cartItemKey, int quantity) async {
    if (_sessionId.isEmpty) {
      throw Exception('No active session');
    }

    try {
      if (quantity <= 0) {
        // Instead of removing, set minimum quantity to 1
        await _firestoreService.updateItemQuantity(_sessionId, cartItemKey, 1);
      } else {
        await _firestoreService.updateItemQuantity(
          _sessionId,
          cartItemKey,
          quantity,
        );
      }
    } catch (error) {
      debugPrint('Error updating item quantity: $error');
      throw Exception('Failed to update item quantity');
    }
  }

  // Clear cart
  Future<void> clear() async {
    if (_sessionId.isEmpty) {
      throw Exception('No active session');
    }

    try {
      await _firestoreService.clearCart(_sessionId);
    } catch (error) {
      debugPrint('Error clearing cart: $error');
      throw Exception('Failed to clear cart');
    }
  }

  // Clean up when provider is disposed
  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
