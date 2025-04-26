// lib/screens/shared_cart_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SharedCartScreen extends StatelessWidget {
  const SharedCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Cart'),
      ),
      body: const Center(
        child: Text('Shared cart items will go here'),
      ),
    );
  }
}