import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart'; // Add this import

@RoutePage()
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kWhiteColor,
          ),
        ),
        backgroundColor: kPurpleColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Success Card with slide-in and fade animation
                    SlideInAnimation(
                      beginOffset: const Offset(0, 0.3),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutQuint,
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            kCardBorderRadius,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Success icon with pulse animation
                              SlideInAnimation(
                                beginOffset: const Offset(0, -0.5),
                                duration: const Duration(milliseconds: 1000),
                                delay: true,
                                curve: Curves.elasticOut,
                                child: PulseAnimation(
                                  minScale: 1.0,
                                  maxScale: 1.1,
                                  duration: const Duration(milliseconds: 2000),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: kSuccessColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_outline,
                                      color: kSuccessColor,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Title with slide-in animation
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 600),
                                delay: true,
                                child: Text(
                                  'Thanks for shopping!',
                                  style: kSubheadingTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Description with slide-in animation
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 700),
                                delay: true,
                                child: Text(
                                  'Your shared shopping session has ended successfully.',
                                  textAlign: TextAlign.center,
                                  style: kBodyTextStyle.copyWith(
                                    color: kGreyColor1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Return to home button with pulse animation - now at the bottom
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: SlideInAnimation(
              beginOffset: const Offset(0, 0.2),
              duration: const Duration(milliseconds: 900),
              delay: true,
              child: PulseAnimation(
                minScale: 1.0,
                maxScale: 1.05,
                duration: const Duration(milliseconds: 1800),
                child: PrimaryButton(
                  text: 'RETURN TO HOME',
                  onPressed: () {
                    // Clear the cart and end the session
                    cartProvider.clear();
                    sessionProvider.leaveSession();

                    // Return to home screen and clear navigation stack
                    context.router.pushAndPopUntil(
                      const HomeRoute(),
                      predicate: (_) => false,
                    );
                  },
                  icon: Icons.home,
                  isFullWidth: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
