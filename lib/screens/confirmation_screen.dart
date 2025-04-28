import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

@RoutePage()
class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final totalAmount = cartProvider.totalAmount;
    final participantCount = sessionProvider.getParticipantCount();
    final isCreator = sessionProvider.isCreator;
    final itemCount = cartProvider.itemCount;
    final participants = sessionProvider.getAllParticipants();
    
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Card
              Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: kSuccessColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: kSuccessColor,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Purchase Complete!',
                        style: kSubheadingTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your shared shopping session has ended successfully.',
                        textAlign: TextAlign.center,
                        style: kBodyTextStyle.copyWith(color: kGreyColor1),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kFadedPurple,
                          borderRadius: BorderRadius.circular(kButtonBorderRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Amount: ',
                              style: kBodyTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: kPurpleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SectionHeader(
                title: 'Order Summary',
              ),
              
              // Shopping details card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: kFadedPurple,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              participantCount > 0 ? Icons.people : Icons.person,
                              color: kPurpleColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shopping Session',
                                  style: kTitleTextStyle,
                                ),
                                Text(
                                  isCreator ? 'Created by you' : 'Created by ${sessionProvider.currentSession?.creatorName ?? 'Creator'}',
                                  style: kCaptionTextStyle,
                                ),
                              ],
                            ),
                          ),
                          StatusBadge(
                            text: 'Completed',
                            isActive: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Order details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Items purchased:',
                            style: kBodyTextStyle,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kFadedPurple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$itemCount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPurpleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Session participants:',
                            style: kBodyTextStyle,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kFadedPurple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$participantCount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPurpleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Show participants
              if (participants.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Participants',
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kCardBorderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: participants.map((name) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: name == sessionProvider.currentUserName 
                              ? kFadedPurple
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: name == sessionProvider.currentUserName
                                  ? kPurpleColor
                                  : Colors.grey[400],
                              child: Text(
                                name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
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
                      )).toList(),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 40),
              
              // Return to home button
              PrimaryButton(
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
            ],
          ),
        ),
      ),
    );
  }
}