import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart';
import '../widgets/responsive_widget.dart';

@RoutePage()
class InviteLandingPage extends StatefulWidget {
  const InviteLandingPage({super.key});

  @override
  State<InviteLandingPage> createState() => _InviteLandingPageState();
}

class _InviteLandingPageState extends State<InviteLandingPage> {
  final _friendNameController = TextEditingController();
  late String _sessionId;

  @override
  void initState() {
    super.initState();
    // Generate random session ID with Faker
    final faker = Faker();
    _sessionId = faker.guid.guid();

    // Use the actual session creator name if possible
    final sessionProvider = Provider.of<SessionProvider>(
      context,
      listen: false,
    );
    if (sessionProvider.currentSession != null) {
    } else {}
  }

  @override
  void dispose() {
    _friendNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final defaultPadding = isSmallScreen ? 16.0 : kDefaultPadding;
        final titleFontSize = isSmallScreen ? 18.0 : 22.0;
        final cardPadding = isSmallScreen ? 12.0 : 16.0;
        final spacingHeight = isSmallScreen ? 12.0 : 16.0;
        final smallSpacingHeight = isSmallScreen ? 8.0 : 12.0;
        final tinySpacingHeight = isSmallScreen ? 4.0 : 6.0;
        final avatarRadius = isSmallScreen ? 28.0 : 32.0;
        final iconSize = isSmallScreen ? 30.0 : 36.0;
        final tinyIconSize = isSmallScreen ? 8.0 : 10.0;
        final borderRadius = isSmallScreen ? 10.0 : 12.0;

        final headingStyle = kSubheadingTextStyle.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 16.0 : kSubheadingTextStyle.fontSize,
        );

        final bodyStyle = kBodyTextStyle.copyWith(
          fontSize: isSmallScreen ? 14.0 : kBodyTextStyle.fontSize,
        );

        final titleStyle = kTitleTextStyle.copyWith(
          fontSize: isSmallScreen ? 16.0 : kTitleTextStyle.fontSize,
        );

        final captionStyle = kCaptionTextStyle.copyWith(
          fontSize: isSmallScreen ? 10.0 : kCaptionTextStyle.fontSize,
        );

        final smallCaptionStyle = kCaptionTextStyle.copyWith(
          color: kGreyColor1,
          fontSize: isSmallScreen ? 10.0 : 12.0,
        );

        return Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: AppBar(
            title: Text(
              'Join Session',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: kWhiteColor,
              ),
            ),
            backgroundColor: kPurpleColor,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SlideInAnimation(
                          beginOffset: const Offset(0, 0.3),
                          duration: const Duration(milliseconds: 600),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.only(bottom: spacingHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                kCardBorderRadius,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(cardPadding),
                              child: Column(
                                children: [
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, -0.2),
                                    duration: const Duration(milliseconds: 800),
                                    delay: true,
                                    child: PulseAnimation(
                                      minScale: 1.0,
                                      maxScale: 1.1,
                                      duration: const Duration(
                                        milliseconds: 1500,
                                      ),
                                      child: CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: kFadedPurple,
                                        child: Icon(
                                          Icons.shopping_cart,
                                          size: iconSize,
                                          color: kPurpleColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacingHeight),
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 700),
                                    delay: true,
                                    child: Text(
                                      'Your friend/family is inviting you to shop',
                                      style: headingStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // Removed the creator name message and participants bar
                                ],
                              ),
                            ),
                          ),
                        ),

                        SlideInAnimation(
                          beginOffset: const Offset(0, 0.3),
                          duration: const Duration(milliseconds: 700),
                          delay: true,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 600),
                                    delay: true,
                                    child: Text(
                                      'Enter Your Name',
                                      style: titleStyle,
                                    ),
                                  ),
                                  SizedBox(height: tinySpacingHeight),
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 650),
                                    delay: true,
                                    child: Text(
                                      'Your name will be visible to other shoppers',
                                      style: captionStyle,
                                    ),
                                  ),
                                  SizedBox(height: smallSpacingHeight),
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 700),
                                    delay: true,
                                    child: TextField(
                                      controller: _friendNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Your Name',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            borderRadius,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: kPurpleColor,
                                          size: isSmallScreen ? 18.0 : 20.0,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            borderRadius,
                                          ),
                                          borderSide: BorderSide(
                                            color: kPurpleColor,
                                            width: isSmallScreen ? 1.5 : 2.0,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: isSmallScreen ? 12.0 : 16.0,
                                          horizontal:
                                              isSmallScreen ? 10.0 : 12.0,
                                        ),
                                      ),
                                      style: bodyStyle,
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

                SizedBox(height: spacingHeight),

                SlideInAnimation(
                  beginOffset: const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 800),
                  delay: true,
                  child: PulseAnimation(
                    minScale: 1.0,
                    maxScale: 1.05,
                    duration: const Duration(milliseconds: 1800),
                    child: PrimaryButton(
                      text: 'START SHOPPING',
                      onPressed: () {
                        if (_friendNameController.text.isNotEmpty) {
                          sessionProvider.setCurrentUserName(
                            _friendNameController.text,
                          );
                          sessionProvider.joinSession(
                            _sessionId,
                            _friendNameController.text,
                          );
                          context.router.push(const ProductListRoute());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please enter your name',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 12.0 : 14.0,
                                ),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: Icons.shopping_bag_outlined,
                      isFullWidth: true,
                    ),
                  ),
                ),

                SizedBox(height: smallSpacingHeight),

                SlideInAnimation(
                  beginOffset: const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 850),
                  delay: true,
                  child: SecondaryButton(
                    text: 'CANCEL',
                    onPressed: () {
                      context.router.pop();
                    },
                    isFullWidth: true,
                  ),
                ),

                SizedBox(height: spacingHeight),

                SlideInAnimation(
                  beginOffset: const Offset(0, 0.1),
                  duration: const Duration(milliseconds: 900),
                  delay: true,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 3.0 : 4.0),
                          decoration: BoxDecoration(
                            color: kSuccessColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 12.0 : 16.0,
                            ),
                          ),
                          child: Icon(
                            Icons.lock,
                            size: tinyIconSize,
                            color: kSuccessColor,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 4.0 : 6.0),
                        Text(
                          'Secure shopping session',
                          style: smallCaptionStyle,
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
