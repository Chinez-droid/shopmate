import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart';

@RoutePage()
class SharedCartScreen extends StatelessWidget {
  const SharedCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final cart = cartProvider.items;
    // Removed sessionName and participants variables as they're no longer needed
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
            // Removed session info bar
            // Removed participants row

            // Cart title with slide-in animation
            SlideInAnimation(
              beginOffset: const Offset(0, 0.1),
              duration: const Duration(milliseconds: 600),
              delay: true,
              child: Padding(
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
            ),

            // Cart items with staggered animations
            Expanded(
              child:
                  cart.isEmpty
                      ? SlideInAnimation(
                        beginOffset: const Offset(0, 0.2),
                        duration: const Duration(milliseconds: 700),
                        delay: true,
                        child: Center(
                          child: EmptyStateView(
                            icon: Icons.shopping_cart_outlined,
                            message:
                                'Your shared cart is empty.\nAdd some products to get started!',
                            actionText: 'Browse Products',
                            onAction: () => context.router.pop(),
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                        ),
                        itemCount: cart.length,
                        itemBuilder: (ctx, i) {
                          final item = cart.values.toList()[i];

                          return SlideInAnimation(
                            beginOffset: const Offset(0, 0.1),
                            duration: Duration(milliseconds: 400 + (i * 100)),
                            delay: true,
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  kCardBorderRadius,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image placeholder with subtle pulse animation
                                    PulseAnimation(
                                      minScale: 1.0,
                                      maxScale: 1.03,
                                      duration: const Duration(
                                        milliseconds: 2000,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          color: kFadedPurple,
                                          child: Center(
                                            child: Icon(
                                              Icons.image,
                                              color: kPurpleColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Item details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      item.addedBy ==
                                                              sessionProvider
                                                                  .currentUserName
                                                          ? kFadedPurple
                                                          : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      size: 12,
                                                      color:
                                                          item.addedBy ==
                                                                  sessionProvider
                                                                      .currentUserName
                                                              ? kPurpleColor
                                                              : Colors
                                                                  .grey[700],
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      item.addedBy,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            item.addedBy ==
                                                                    sessionProvider
                                                                        .currentUserName
                                                                ? kPurpleColor
                                                                : Colors
                                                                    .grey[700],
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                    // Delete button removed
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),

            // Cart summary with slide-up animation
            if (cart.isNotEmpty)
              SlideInAnimation(
                beginOffset: const Offset(0, 0.2),
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
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
                          const Text('Total Amount', style: kTitleTextStyle),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: kPurpleColor,
                              borderRadius: BorderRadius.circular(
                                kButtonBorderRadius,
                              ),
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
                      // Pulse animation for the primary action button
                      PulseAnimation(
                        minScale: 1.0,
                        maxScale: 1.05,
                        duration: const Duration(milliseconds: 1800),
                        child: PrimaryButton(
                          text: 'Done Shopping',
                          onPressed: () {
                            context.router.push(const ConfirmationRoute());
                          },
                          icon: Icons.check_circle_outline,
                          isFullWidth: true,
                        ),
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