import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';

@RoutePage()
class SharedCartScreen extends StatelessWidget {
  const SharedCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final cart = cartProvider.items;
    final isCreator = sessionProvider.isCreator;
    final sessionName = sessionProvider.currentSession?.name ?? 'Shopping Session';
    final participants = sessionProvider.getAllParticipants();
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.router.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shared Cart${isCreator ? " (Creator)" : ""}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
          ),
        ),
        body: Column(
          children: [
            // Session info card
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.people,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sessionName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                isCreator ? 'Created by you' : 'Created by ${sessionProvider.currentSession?.creatorName}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (participants.isNotEmpty) ...[
                      const Text(
                        'Participants:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 8,
                        children: participants.map((name) => Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              name[0].toUpperCase(),
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          label: Text(name),
                          backgroundColor: name == sessionProvider.currentUserName 
                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                              : null,
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Cart items
            Expanded(
              child: cart.isEmpty
                  ? const Center(
                      child: Text(
                        'No items in cart yet.\nAdd some products!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (ctx, i) {
                        final item = cart.values.toList()[i];
                        final productId = cart.keys.toList()[i];
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: FittedBox(
                                    child: Text('\$${item.price}'),
                                  ),
                                ),
                              ),
                              title: Text(item.productName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total: \$${item.totalPrice.toStringAsFixed(2)}'),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Added by: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: item.addedBy == sessionProvider.currentUserName
                                              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                                              : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item.addedBy,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: item.addedBy == sessionProvider.currentUserName
                                                ? Theme.of(context).colorScheme.primary
                                                : Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${item.quantity} ×'),
                                  // Only allow deletion by the person who added the item or the creator
                                  if (item.addedBy == sessionProvider.currentUserName || isCreator)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        cartProvider.removeItem(productId);
                                      },
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Cart summary
            if (cart.isNotEmpty)
              Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      Chip(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: Text(
                          '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.router.push(const ConfirmationRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('DONE SHOPPING'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}