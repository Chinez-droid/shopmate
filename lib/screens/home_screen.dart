import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';
import 'package:shopmate/widgets/animations_widget.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/responsive_widget.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutQuint,
    );
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final faker = Faker();
    // Get mock sessions from provider
    final mockSessions = sessionProvider.getMockSessions();

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final defaultPadding = isSmallScreen ? 16.0 : kDefaultPadding;
        final headerBottomPadding = isSmallScreen ? 30.0 : 40.0;
        final cardPadding = isSmallScreen ? 16.0 : 20.0;
        final spacingHeight = isSmallScreen ? 12.0 : 16.0;

        final headingStyle = kHeadingTextStyle.copyWith(
          color: kWhiteColor,
          height: 1.2,
          fontSize: isSmallScreen ? 24.0 : kHeadingTextStyle.fontSize,
        );

        final bodyStyle = kBodyTextStyle.copyWith(
          color: kWhiteColor.withValues(alpha: 0.9),
          fontSize: isSmallScreen ? 14.0 : kBodyTextStyle.fontSize,
        );

        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            title: AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, (1 - _headerAnimation.value) * -30),
                  child: Opacity(
                    opacity: _headerAnimation.value,
                    child: Text(
                      'Shopmate',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: isSmallScreen ? 20.0 : 22.0,
                        fontWeight: FontWeight.w600,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            backgroundColor: kPurpleColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header gradient container with animation
                AnimatedBuilder(
                  animation: _headerAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            kPurpleColor,
                            kPurpleColor.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: defaultPadding,
                        top: defaultPadding,
                        bottom: headerBottomPadding,
                      ),
                      child: Transform.translate(
                        offset: Offset(0, (1 - _headerAnimation.value) * 30),
                        child: Opacity(
                          opacity: _headerAnimation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shop together with\nfriends and family',
                                style: headingStyle,
                              ),
                              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
                              Text(
                                'Create or join a shopping session',
                                style: bodyStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Action Cards with animated entrance
                      SlideInAnimation(
                        beginOffset: const Offset(0, 0.2),
                        duration: const Duration(milliseconds: 600),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PulseAnimation(
                                  duration: const Duration(milliseconds: 2000),
                                  minScale: 1.0,
                                  maxScale: 1.04,
                                  child: PrimaryButton(
                                    text: 'Start Cart Session',
                                    onPressed: () {
                                      // Set a random name if none exists yet
                                      if (sessionProvider
                                          .currentUserName
                                          .isEmpty) {
                                        sessionProvider.setCurrentUserName(
                                          faker.person.firstName(),
                                        );
                                      }
                                      context.router.push(
                                        const CartInviteRoute(),
                                      );
                                    },
                                    icon: Icons.shopping_cart,
                                    isFullWidth: true,
                                  ),
                                ),
                                SizedBox(height: spacingHeight),
                                SecondaryButton(
                                  text: 'Join as Friend',
                                  onPressed: () {
                                    if (sessionProvider
                                        .currentUserName
                                        .isEmpty) {
                                      sessionProvider.setCurrentUserName(
                                        faker.person.firstName(),
                                      );
                                    }

                                    // Navigate directly to the invite landing page
                                    context.router.push(
                                      const InviteLandingRoute(),
                                    );
                                  },
                                  icon: Icons.link,
                                  isFullWidth: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SlideInAnimation(
                        beginOffset: const Offset(0, 0.15),
                        duration: const Duration(milliseconds: 600),
                        delay: true,
                        curve: Curves.easeOutQuint,
                        child: const SectionHeader(
                          title: 'Your Shopping Sessions',
                        ),
                      ),

                      // Display mock sessions from provider with staggered animations
                      if (mockSessions.isEmpty)
                        SlideInAnimation(
                          beginOffset: const Offset(0, 0.1),
                          duration: const Duration(milliseconds: 600),
                          delay: true,
                          curve: Curves.easeOutQuint,
                          child: const EmptyStateView(
                            icon: Icons.shopping_bag_outlined,
                            message:
                                'No shopping sessions yet. Start a new session to invite friends and family!',
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mockSessions.length,
                          itemBuilder: (context, index) {
                            final session = mockSessions[index];
                            return SlideInAnimation(
                              beginOffset: const Offset(0, 0.1),
                              duration: const Duration(milliseconds: 600),
                              delay: true,
                              curve: Curves.easeOutQuint,
                              child: SessionCard(
                                title: session.name,
                                creatorName:
                                    session.creatorName ==
                                            sessionProvider.currentUserName
                                        ? 'Created by you'
                                        : session.creatorName,
                                isActive: session.isActive,
                                createdAt: session.createdAt,
                                participantCount: session.participants.length,
                                onTap: null,
                              ),
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
      },
    );
  }
}
