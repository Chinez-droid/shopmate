// lib/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We'll implement this fully later
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: const Center(
        child: Text('Product list will go here'),
      ),
    );
  }
}