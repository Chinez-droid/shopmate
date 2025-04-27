import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class CartInviteScreen extends StatefulWidget {
  const CartInviteScreen({super.key});

  @override
  State<CartInviteScreen> createState() => _CartInviteScreenState();
}

class _CartInviteScreenState extends State<CartInviteScreen> {
  final _nameController = TextEditingController();
  bool _sessionCreated = false;
  String _inviteLink = '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createSession() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first')),
      );
      return;
    }

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    sessionProvider.setCurrentUserName(_nameController.text);
    
    // Create the session
    sessionProvider.createNewSession();
    // Get the invite link
    final link = sessionProvider.getShareUrl();
    
    setState(() {
      _sessionCreated = true;
      _inviteLink = link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Shopping Cart')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_sessionCreated) ...[
                // Session creation form
                const Text(
                  'Create a new shopping session',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _createSession,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Create Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Session created, show sharing options
                Text(
                  'Hi, ${_nameController.text}!',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your cart session is ready to share with friends and family:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[100],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _inviteLink,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _inviteLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link copied to clipboard'),
                            ),
                          );
                        },
                        tooltip: 'Copy link',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _inviteLink));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied to clipboard')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Link'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Simulate an email address
                        final String mockEmail = 'friend@gmail.com';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email sent to $mockEmail')),
                        );
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Send Invite'),
                    ),
                  ],
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Start Shopping'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}