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
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final titleFontSize = isSmallScreen ? 20.0 : 22.0;
        final defaultPadding = isSmallScreen ? 16.0 : kDefaultPadding;
        final cardPadding = isSmallScreen ? 20.0 : 24.0;
        final iconSize = isSmallScreen ? 45.0 : 50.0;
        final containerSize = isSmallScreen ? 70.0 : 80.0;
        final spacingHeight = isSmallScreen ? 16.0 : 20.0;
        final smallSpacingHeight = isSmallScreen ? 6.0 : 8.0;

        final titleStyle = kSubheadingTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: kSecondaryColor,
          fontSize: isSmallScreen ? 18.0 : kSubheadingTextStyle.fontSize,
        );

        final descriptionStyle = kBodyTextStyle.copyWith(
          color: kGreyColor1,
          fontSize: isSmallScreen ? 14.0 : kBodyTextStyle.fontSize,
        );

        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            title: Text(
              'Order Confirmation',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: titleFontSize,
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
                    padding: EdgeInsets.all(defaultPadding),
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
                              padding: EdgeInsets.all(cardPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Success icon with pulse animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, -0.5),
                                    duration: const Duration(
                                      milliseconds: 1000,
                                    ),
                                    delay: true,
                                    curve: Curves.elasticOut,
                                    child: PulseAnimation(
                                      minScale: 1.0,
                                      maxScale: 1.1,
                                      duration: const Duration(
                                        milliseconds: 2000,
                                      ),
                                      child: Container(
                                        width: containerSize,
                                        height: containerSize,
                                        decoration: BoxDecoration(
                                          color: kSuccessColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_circle_outline,
                                          color: kSuccessColor,
                                          size: iconSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacingHeight),
                                  // Title with slide-in animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 600),
                                    delay: true,
                                    child: Text(
                                      'Thanks for shopping!',
                                      style: titleStyle,
                                    ),
                                  ),
                                  SizedBox(height: smallSpacingHeight),
                                  // Description with slide-in animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 700),
                                    delay: true,
                                    child: Text(
                                      'Your shared shopping session has ended successfully.',
                                      textAlign: TextAlign.center,
                                      style: descriptionStyle,
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

              // Return to home button with pulse animation
              Padding(
                padding: EdgeInsets.all(defaultPadding),
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
      },
    );
  }
}
