import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class InviteLandingPage extends StatefulWidget {
  const InviteLandingPage({super.key});

  @override
  State<InviteLandingPage> createState() => _InviteLandingPageState();
}

class _InviteLandingPageState extends State<InviteLandingPage> {
  final _friendNameController = TextEditingController();
  late String _sessionId;
  
  @override
  void initState() {
    super.initState();
    // Generate random session ID with Faker
    final faker = Faker();
    _sessionId = faker.guid.guid();
  }
  
  @override
  void dispose() {
    _friendNameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    // Use the sessionProvider's creator name
    String inviterName = sessionProvider.currentUserName;
    
    // If for some reason the inviter name isn't set, use a fallback
    if (inviterName.isEmpty) {
      inviterName = 'Your friend';
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Shopping Session'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      size: 64,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your friend/family is inviting you to shop',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$inviterName has invited you to join their shopping cart!',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              TextField(
                controller: _friendNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () {
                  if (_friendNameController.text.isNotEmpty) {
                    sessionProvider.setCurrentUserName(_friendNameController.text);
                    sessionProvider.joinSession(_sessionId, _friendNameController.text);
                    context.router.push(const ProductListRoute());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your name')),
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
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  context.router.pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}