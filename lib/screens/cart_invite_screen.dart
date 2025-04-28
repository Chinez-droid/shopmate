import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

@RoutePage()
class CartInviteScreen extends StatefulWidget {
  const CartInviteScreen({super.key});

  @override
  State<CartInviteScreen> createState() => _CartInviteScreenState();
}

class _CartInviteScreenState extends State<CartInviteScreen> {
  final _nameController = TextEditingController();
  bool _sessionCreated = false;
  String _inviteLink = '';
  int _inviteSent = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createSession() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first')),
      );
      return;
    }

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    sessionProvider.setCurrentUserName(_nameController.text);
    
    // Create the session
    sessionProvider.createNewSession();
    // Get the invite link
    final link = sessionProvider.getShareUrl();
    
    setState(() {
      _sessionCreated = true;
      _inviteLink = link;
    });
  }

  void _sendInvite() {
    setState(() {
      _inviteSent++;
    });
    
    // Simulate an email address
    final String mockEmail = 'friend$_inviteSent@gmail.com';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invite sent to $mockEmail')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'Create Shopping Cart',
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
            // Header gradient container (similar to home screen)
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
                    !_sessionCreated 
                        ? 'Create a new\nshopping session' 
                        : 'Share with friends\nand family',
                    style: kHeadingTextStyle.copyWith(
                      color: kWhiteColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    !_sessionCreated 
                        ? 'Set up a cart to shop together'
                        : 'Invite others to join your shopping cart',
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
                  if (!_sessionCreated) ...[
                    // Session creation card
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kCardBorderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Information',
                              style: kTitleTextStyle,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Your Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: PrimaryButton(
                                text: 'Create Session',
                                onPressed: _createSession,
                                icon: Icons.add_shopping_cart,
                                isFullWidth: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                'This will create a cart you can share with others',
                                style: kCaptionTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Session created, show sharing options
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kCardBorderRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kFadedPurple,
                                  child: Icon(
                                    Icons.person,
                                    color: kPurpleColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, ${_nameController.text}!',
                                      style: kTitleTextStyle,
                                    ),
                                    const Text(
                                      'Your cart session is ready',
                                      style: kCaptionTextStyle,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                StatusBadge(
                                  text: 'Active',
                                  isActive: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Invite Link',
                              style: kSubheadingTextStyle,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: kGreyColor2),
                                borderRadius: BorderRadius.circular(kButtonBorderRadius),
                                color: Colors.grey[100],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _inviteLink,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy, color: kPurpleColor),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _inviteLink));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Link copied to clipboard'),
                                        ),
                                      );
                                    },
                                    tooltip: 'Copy link',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Invitation Stats
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kButtonBorderRadius),
                                color: kFadedPurple,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invitation Status',
                                    style: kTitleTextStyle.copyWith(
                                      color: kPurpleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.send, size: 16, color: kPurpleColor),
                                          const SizedBox(width: 8),
                                          const Text('Invitations sent:'),
                                        ],
                                      ),
                                      Text(
                                        '$_inviteSent', 
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // In a real app, you'd show how many have joined
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.group, size: 16, color: kPurpleColor),
                                          const SizedBox(width: 8),
                                          const Text('Friends joined:'),
                                        ],
                                      ),
                                      // This would be real data in a complete app
                                      Text(
                                        '${_inviteSent > 0 ? _inviteSent - 1 : 0}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    text: 'Copy Link',
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _inviteLink));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Link copied to clipboard')),
                                      );
                                    },
                                    icon: Icons.copy,
                                    isFullWidth: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Send Invite',
                                    onPressed: _sendInvite,
                                    icon: Icons.share,
                                    isFullWidth: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            PrimaryButton(
                              text: 'Start Shopping',
                              onPressed: () {
                                context.router.push(const ProductListRoute());
                              },
                              icon: Icons.shopping_bag_outlined,
                              isFullWidth: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}