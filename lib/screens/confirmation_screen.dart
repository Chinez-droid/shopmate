// lib/screens/confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


@RoutePage()
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You!'),
      ),
      body: const Center(
        child: Text('Thank you for shopping!'),
      ),
    );
  }
}