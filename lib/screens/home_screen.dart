import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

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
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'Shopmate',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kWhiteColor,
          ),
        ),
        backgroundColor: kPurpleColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header gradient container
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPurpleColor, kPurpleColor.withValues(alpha: 0.0)],
                  stops: const [0.0, 1.0],
                ),
              ),
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: kDefaultPadding,
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop together with\nfriends and family',
                    style: kHeadingTextStyle.copyWith(
                      color: kWhiteColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create or join a shopping session',
                    style: kBodyTextStyle.copyWith(
                      color: kWhiteColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Action Cards
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kCardBorderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PrimaryButton(
                            text: 'Start Cart Session',
                            onPressed: () {
                              // Set a random name if none exists yet
                              if (sessionProvider.currentUserName.isEmpty) {
                                sessionProvider.setCurrentUserName(
                                  faker.person.firstName(),
                                );
                              }
                              context.router.push(const CartInviteRoute());
                            },
                            icon: Icons.shopping_cart,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 16),
                          SecondaryButton(
                            text: 'Join as Friend',
                            onPressed: () {
                              // Set a random name if none exists yet
                              if (sessionProvider.currentUserName.isEmpty) {
                                sessionProvider.setCurrentUserName(
                                  faker.person.firstName(),
                                );
                              }

                              // Navigate directly to the invite landing page
                              context.router.push(const InviteLandingRoute());
                            },
                            icon: Icons.link,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sessions section
                  const SectionHeader(title: 'Your Shopping Sessions'),

                  // Display mock sessions from provider
                  if (mockSessions.isEmpty)
                    const EmptyStateView(
                      icon: Icons.shopping_bag_outlined,
                      message:
                          'No shopping sessions yet. Start a new session to invite friends and family!',
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mockSessions.length,
                      itemBuilder: (context, index) {
                        final session = mockSessions[index];
                        return SessionCard(
                          title: session.name,
                          creatorName:
                              session.creatorName ==
                                      sessionProvider.currentUserName
                                  ? 'Created by you'
                                  : session.creatorName,
                          isActive: session.isActive,
                          createdAt: session.createdAt,
                          participantCount: session.participants.length,
                          // Remove the onTap property or set it to null
                          onTap:
                              () {}, // Empty callback to make card selectable but do nothing
                        );
                      },
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
