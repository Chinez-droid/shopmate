// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopmate'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  sessionProvider.setCurrentUserName(_nameController.text);
                  context.router.push(const CartInviteRoute());
                }
              },
              child: const Text('Start Shopping Session'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  sessionProvider.setCurrentUserName(_nameController.text);
                  context.router.push(const InviteLandingRoute());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your name first')),
                  );
                }
              },
              child: const Text('Join as Friend'),
            ),
          ],
        ),
      ),
    );
  }
}