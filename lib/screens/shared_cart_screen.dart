import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart';
import '../widgets/responsive_widget.dart';

@RoutePage()
class SharedCartScreen extends StatefulWidget {
  const SharedCartScreen({super.key});

  @override
  State<SharedCartScreen> createState() => _SharedCartScreenState();
}

class _SharedCartScreenState extends State<SharedCartScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final sessionProvider = Provider.of<SessionProvider>(
        context,
        listen: false,
      );
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Set active session ID for cart provider to establish Firestore stream
      if (sessionProvider.currentSession != null) {
        cartProvider.setActiveSession(
          sessionProvider.currentSession!.sessionId,
        );
        _isInitialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final cart = cartProvider.items;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final padding = isSmallScreen ? 12.0 : kDefaultPadding;
        final titleFontSize = isSmallScreen ? 18.0 : 22.0;
        final spacingHeight = isSmallScreen ? 12.0 : 16.0;
        final cardPadding = isSmallScreen ? 12.0 : 14.0;
        final iconSize = isSmallScreen ? 16.0 : 20.0;
        final smallIconSize = isSmallScreen ? 10.0 : 12.0;
        final imageSize = isSmallScreen ? 50.0 : 60.0;
        final borderRadius = isSmallScreen ? 10.0 : 12.0;

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
                  fontFamily: 'Roboto',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: kWhiteColor,
                ),
              ),
              backgroundColor: kPurpleColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, size: isSmallScreen ? 20.0 : 24.0),
                onPressed: () => context.router.pop(),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cart title with slide-in animation
                SlideInAnimation(
                  beginOffset: const Offset(0, 0.1),
                  duration: const Duration(milliseconds: 600),
                  delay: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      top: isSmallScreen ? 12.0 : 16.0,
                      bottom: isSmallScreen ? 6.0 : 8.0,
                    ),
                    child: Text(
                      cart.isEmpty ? 'Your cart is empty' : 'Cart Items',
                      style: kSubheadingTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            isSmallScreen
                                ? 16.0
                                : kSubheadingTextStyle.fontSize,
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
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            itemCount: cart.length,
                            itemBuilder: (ctx, i) {
                              final item = cart.values.toList()[i];
                              final bool isCurrentUserItem =
                                  item.addedBy ==
                                  sessionProvider.currentUserName;

                              return SlideInAnimation(
                                beginOffset: const Offset(0, 0.1),
                                duration: Duration(
                                  milliseconds: 400 + (i * 100),
                                ),
                                delay: true,
                                child: Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(
                                    bottom: isSmallScreen ? 8.0 : 12.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      kCardBorderRadius,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(cardPadding),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Image placeholder with subtle pulse animation
                                        PulseAnimation(
                                          minScale: 1.0,
                                          maxScale: 1.03,
                                          duration: const Duration(
                                            milliseconds: 2000,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              borderRadius,
                                            ),
                                            child: Container(
                                              width: imageSize,
                                              height: imageSize,
                                              color: kFadedPurple,
                                              child: Center(
                                                child: Icon(
                                                  Icons.image,
                                                  color: kPurpleColor,
                                                  size: iconSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: isSmallScreen ? 10.0 : 14.0,
                                        ),
                                        // Item details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.productName,
                                                style: kTitleTextStyle.copyWith(
                                                  fontSize:
                                                      isSmallScreen
                                                          ? 14.0
                                                          : kTitleTextStyle
                                                              .fontSize,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height:
                                                    isSmallScreen ? 2.0 : 4.0,
                                              ),
                                              Text(
                                                '${item.quantity} × \$${item.price}',
                                                style: kBodyTextStyle.copyWith(
                                                  fontSize:
                                                      isSmallScreen
                                                          ? 12.0
                                                          : kBodyTextStyle
                                                              .fontSize,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    isSmallScreen ? 6.0 : 8.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              isSmallScreen
                                                                  ? 6.0
                                                                  : 8.0,
                                                          vertical:
                                                              isSmallScreen
                                                                  ? 3.0
                                                                  : 4.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isCurrentUserItem
                                                              ? kFadedPurple
                                                              : Colors
                                                                  .grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            isSmallScreen
                                                                ? 10.0
                                                                : 12.0,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          size: smallIconSize,
                                                          color:
                                                              isCurrentUserItem
                                                                  ? kPurpleColor
                                                                  : Colors
                                                                      .grey[700],
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              isSmallScreen
                                                                  ? 3.0
                                                                  : 4.0,
                                                        ),
                                                        Text(
                                                          item.addedBy,
                                                          style: TextStyle(
                                                            fontSize:
                                                                isSmallScreen
                                                                    ? 10.0
                                                                    : 11.0,
                                                            color:
                                                                isCurrentUserItem
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
                                                    style: kBodyTextStyle
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: kPurpleColor,
                                                          fontSize:
                                                              isSmallScreen
                                                                  ? 12.0
                                                                  : kBodyTextStyle
                                                                      .fontSize,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
                      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
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
                              Text(
                                'Total Amount',
                                style: kTitleTextStyle.copyWith(
                                  fontSize:
                                      isSmallScreen
                                          ? 16.0
                                          : kTitleTextStyle.fontSize,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 10.0 : 14.0,
                                  vertical: isSmallScreen ? 4.0 : 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: kPurpleColor,
                                  borderRadius: BorderRadius.circular(
                                    kButtonBorderRadius,
                                  ),
                                ),
                                child: Text(
                                  '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 16.0 : 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacingHeight),
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
      },
    );
  }
}
