import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart'; // Add this import

@RoutePage()
class InviteLandingPage extends StatefulWidget {
  const InviteLandingPage({super.key});

  @override
  State<InviteLandingPage> createState() => _InviteLandingPageState();
}

class _InviteLandingPageState extends State<InviteLandingPage> {
  final _friendNameController = TextEditingController();
  late String _sessionId;
  String _creatorName = 'Your friend';
  int _participantCount = 0;

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
      _creatorName = sessionProvider.currentSession!.creatorName;
      _participantCount = sessionProvider.currentSession!.participants.length;
    } else {
      // For a real app, we would retrieve session details here
      // For now, generate a random creator name and participant count
      _creatorName = faker.person.firstName();
      _participantCount = faker.randomGenerator.integer(
        3,
      ); // 0-2 other participants
    }
  }

  @override
  void dispose() {
    _friendNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'Join Session',
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
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
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
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            kCardBorderRadius,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SlideInAnimation(
                                beginOffset: const Offset(0, -0.2),
                                duration: const Duration(milliseconds: 800),
                                delay: true,
                                child: PulseAnimation(
                                  minScale: 1.0,
                                  maxScale: 1.1,
                                  duration: const Duration(milliseconds: 1500),
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: kFadedPurple,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      size: 36,
                                      color: kPurpleColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 700),
                                delay: true,
                                child: Text(
                                  'Your friend/family is inviting you to shop',
                                  style: kSubheadingTextStyle.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 800),
                                delay: true,
                                child: Text(
                                  '$_creatorName has invited you to join their shopping cart!',
                                  style: kBodyTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (_participantCount > 0)
                                SlideInAnimation(
                                  beginOffset: const Offset(0, 0.2),
                                  duration: const Duration(milliseconds: 900),
                                  delay: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kFadedPurple,
                                      borderRadius: BorderRadius.circular(
                                        kButtonBorderRadius,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 14,
                                          color: kPurpleColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$_participantCount other ${_participantCount == 1 ? 'person' : 'people'} shopping',
                                          style: TextStyle(
                                            color: kPurpleColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 600),
                                delay: true,
                                child: Text(
                                  'Enter Your Name',
                                  style: kTitleTextStyle,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SlideInAnimation(
                                beginOffset: const Offset(0, 0.2),
                                duration: const Duration(milliseconds: 650),
                                delay: true,
                                child: Text(
                                  'Your name will be visible to other shoppers',
                                  style: kCaptionTextStyle,
                                ),
                              ),
                              const SizedBox(height: 12),
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
                                        kButtonBorderRadius,
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: kPurpleColor,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        kButtonBorderRadius,
                                      ),
                                      borderSide: const BorderSide(
                                        color: kPurpleColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  style: kBodyTextStyle,
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

            const SizedBox(height: 16),

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
                        const SnackBar(content: Text('Please enter your name')),
                      );
                    }
                  },
                  icon: Icons.shopping_bag_outlined,
                  isFullWidth: true,
                ),
              ),
            ),

            const SizedBox(height: 12),

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

            const SizedBox(height: 16),

            SlideInAnimation(
              beginOffset: const Offset(0, 0.1),
              duration: const Duration(milliseconds: 900),
              delay: true,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: kSuccessColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.lock, size: 10, color: kSuccessColor),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Secure shopping session',
                      style: kCaptionTextStyle.copyWith(
                        color: kGreyColor1,
                        fontSize: 12,
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