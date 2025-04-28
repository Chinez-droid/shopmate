import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

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
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: Text(
            'Shared Cart',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: kWhiteColor,
            ),
          ),
          backgroundColor: kPurpleColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Compact session info bar
            Container(
              color: kPurpleColor,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: 12,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: kWhiteColor.withOpacity(0.2),
                    radius: 16,
                    child: Icon(
                      Icons.people,
                      color: kWhiteColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sessionName,
                          style: kBodyTextStyle.copyWith(
                            color: kWhiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isCreator ? 'Created by you' : 'Created by ${sessionProvider.currentSession?.creatorName}',
                          style: kCaptionTextStyle.copyWith(
                            color: kWhiteColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: 'Active',
                    isActive: true,
                  ),
                ],
              ),
            ),

            // Compact participants row
            if (participants.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: 8,
                ),
                color: kWhiteColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Shopping with: ',
                        style: kCaptionTextStyle.copyWith(color: Colors.grey[600]),
                      ),
                      ...participants.map((name) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: name == sessionProvider.currentUserName
                                ? kFadedPurple
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: name == sessionProvider.currentUserName
                                    ? kPurpleColor
                                    : Colors.grey[400],
                                child: Text(
                                  name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: name == sessionProvider.currentUserName
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: name == sessionProvider.currentUserName
                                      ? kPurpleColor
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            
            // Cart title
            Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: 16,
                bottom: 8,
              ),
              child: Text(
                cart.isEmpty ? 'Your cart is empty' : 'Cart Items',
                style: kSubheadingTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Cart items
            Expanded(
              child: cart.isEmpty
                  ? Center(
                      child: EmptyStateView(
                        icon: Icons.shopping_cart_outlined,
                        message: 'Your shared cart is empty.\nAdd some products to get started!',
                        actionText: 'Browse Products',
                        onAction: () => context.router.pop(),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      itemCount: cart.length,
                      itemBuilder: (ctx, i) {
                        final item = cart.values.toList()[i];
                        final productId = cart.keys.toList()[i];
                        
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kCardBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Price badge
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: kFadedPurple,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '\$${item.price}', 
                                      style: TextStyle(
                                        color: kPurpleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Item details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: kTitleTextStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.quantity} × \$${item.price}',
                                        style: kBodyTextStyle,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item.addedBy == sessionProvider.currentUserName
                                                  ? kFadedPurple
                                                  : Colors.grey[200],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 12,
                                                  color: item.addedBy == sessionProvider.currentUserName
                                                      ? kPurpleColor
                                                      : Colors.grey[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  item.addedBy,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: item.addedBy == sessionProvider.currentUserName
                                                        ? kPurpleColor
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '\$${item.totalPrice.toStringAsFixed(2)}',
                                            style: kBodyTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kPurpleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete button
                                if (item.addedBy == sessionProvider.currentUserName || isCreator)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () {
                                      cartProvider.removeItem(productId);
                                    },
                                    color: Theme.of(context).colorScheme.error,
                                    padding: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Cart summary
            if (cart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: kTitleTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kPurpleColor,
                            borderRadius: BorderRadius.circular(kButtonBorderRadius),
                          ),
                          child: Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Done Shopping',
                      onPressed: () {
                        context.router.push(const ConfirmationRoute());
                      },
                      icon: Icons.check_circle_outline,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}