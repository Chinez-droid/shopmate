import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:faker/faker.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

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
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    if (sessionProvider.currentSession != null) {
      _creatorName = sessionProvider.currentSession!.creatorName;
      _participantCount = sessionProvider.currentSession!.participants.length;
    } else {
      // For a real app, we would retrieve session details here
      // For now, generate a random creator name and participant count
      _creatorName = faker.person.firstName();
      _participantCount = faker.randomGenerator.integer(3); // 0-2 other participants
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: kFadedPurple,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 42,
                          color: kPurpleColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'You\'ve been invited to shop together',
                        style: kSubheadingTextStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$_creatorName has invited you to join their shopping cart!',
                        style: kBodyTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (_participantCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: kFadedPurple,
                            borderRadius: BorderRadius.circular(kButtonBorderRadius),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: kPurpleColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_participantCount other ${_participantCount == 1 ? 'person' : 'people'} shopping',
                                style: TextStyle(
                                  color: kPurpleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 4,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Your Name',
                        style: kTitleTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your name will be visible to other shoppers',
                        style: kCaptionTextStyle,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _friendNameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kButtonBorderRadius),
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: kPurpleColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kButtonBorderRadius),
                            borderSide: const BorderSide(color: kPurpleColor, width: 2),
                          ),
                        ),
                        style: kBodyTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              PrimaryButton(
                text: 'START SHOPPING',
                onPressed: () {
                  if (_friendNameController.text.isNotEmpty) {
                    sessionProvider.setCurrentUserName(_friendNameController.text);
                    sessionProvider.joinSession(_sessionId, _friendNameController.text);
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
              
              const SizedBox(height: 16),
              
              SecondaryButton(
                text: 'CANCEL',
                onPressed: () {
                  context.router.pop();
                },
                isFullWidth: true,
              ),

              const SizedBox(height: 24),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: kSuccessColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 12,
                        color: kSuccessColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Secure shopping session',
                      style: kCaptionTextStyle.copyWith(
                        color: kGreyColor1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}