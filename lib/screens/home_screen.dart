import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../models/session.dart';
import '../routes/app_router.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final faker = Faker();
    // Get mock sessions from provider
    final mockSessions = sessionProvider.getMockSessions();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopmate'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main actions section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Set a random name if none exists yet
                          if (sessionProvider.currentUserName.isEmpty) {
                            sessionProvider.setCurrentUserName(faker.person.firstName());
                          }
                          context.router.push(const CartInviteRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Start Cart Session', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Simulate opening from an invite link
                          final mockInviteLink = 'app://shop/session/${faker.guid.guid()}';
                          
                          // Set a random name if none exists yet
                          if (sessionProvider.currentUserName.isEmpty) {
                            sessionProvider.setCurrentUserName(faker.person.firstName());
                          }
                          
                          // Show a dialog to simulate clicking on an invite link
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Simulating Invite Link'),
                              content: Text('Opening link: $mockInviteLink'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    context.router.push(const InviteLandingRoute());
                                  },
                                  child: const Text('Open'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.link),
                        label: const Text('Join via Invite Link'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Mock existing sessions section
              const Text(
                'Your Shopping Sessions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              // Display mock sessions from provider
              if (mockSessions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'No shopping sessions yet',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              else
                ...mockSessions.map((session) => _buildSessionCard(
                  context, 
                  session,
                  faker.company.name(), // Random session name
                )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSessionCard(
    BuildContext context, 
    ShoppingSession session,
    String title,
  ) {
    final status = session.isActive ? 'Active' : 'Completed';
    final statusColor = session.isActive ? Colors.green : Colors.grey;
    final hasJoined = session.friendName != null;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Icon(
              hasJoined ? Icons.people : Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 12, color: statusColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(session.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (hasJoined) ...[
                const SizedBox(height: 4),
                Text(
                  'Shopping with ${session.friendName}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                ),
              ],
            ],
          ),
          trailing: session.isActive 
            ? IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  context.router.push(const ProductListRoute());
                },
              )
            : null,
          onTap: () {
            if (session.isActive) {
              context.router.push(const ProductListRoute());
            }
          },
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}