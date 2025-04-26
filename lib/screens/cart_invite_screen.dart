// lib/screens/cart_invite_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class CartInviteScreen extends StatelessWidget {
  const CartInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    // Remove or use the sessionId variable
    final inviteLink = sessionProvider.getShareUrl();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${sessionProvider.currentUserName}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your shopping session has been created. Share the invite link with a friend:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      inviteLink,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite sent to friend')),
                );
              },
              icon: const Icon(Icons.email),
              label: const Text('Send Invite'),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(const ProductListRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text('Start Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}