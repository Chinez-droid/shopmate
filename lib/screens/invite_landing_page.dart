// lib/screens/invite_landing_page.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class InviteLandingPage extends StatefulWidget {
  const InviteLandingPage({super.key});

  @override
  State<InviteLandingPage> createState() => _InviteLandingPageState();
}

class _InviteLandingPageState extends State<InviteLandingPage> {
  final _sessionIdController = TextEditingController();
  
  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Shopping Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your friend has invited you to shop together!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _sessionIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Session ID or Paste Link',
                border: OutlineInputBorder(),
                hintText: 'app://shop/session/xyz123',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Name:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              sessionProvider.currentUserName,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_sessionIdController.text.isNotEmpty) {
                  // Extract session ID from the full link if needed
                  String sessionId = _sessionIdController.text;
                  if (sessionId.contains('app://shop/session/')) {
                    sessionId = sessionId.split('app://shop/session/')[1];
                  }
                  
                  sessionProvider.joinSession(sessionId, sessionProvider.currentUserName);
                  context.router.push(const ProductListRoute());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a session ID or link')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Shopping', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}