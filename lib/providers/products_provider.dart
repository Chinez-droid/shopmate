// lib/providers/products_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Running Shoes',
      price: 99.99,
    ),
    Product(
      id: 'p2',
      name: 'Laptop',
      price: 1299.99,
    ),
    Product(
      id: 'p3',
      name: 'Coffee Mug',
      price: 12.99,
    ),
    Product(
      id: 'p4',
      name: 'Headphones',
      price: 149.99,
    ),
    Product(
      id: 'p5',
      name: 'Backpack',
      price: 59.99,
    ),
    Product(
      id: 'p6',
      name: 'Smart Watch',
      price: 199.99,
    ),
    Product(
      id: 'p7',
      name: 'Wireless Mouse',
      price: 29.99,
    ),
    Product(
      id: 'p8',
      name: 'Bluetooth Speaker',
      price: 79.99,
    ),
  ];

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}