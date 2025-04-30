import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../providers/cart_provider.dart';
import '../routes/app_router.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/animations_widget.dart';

@RoutePage()
class CartInviteScreen extends StatefulWidget {
  const CartInviteScreen({super.key});

  @override
  State<CartInviteScreen> createState() => _CartInviteScreenState();
}

class _CartInviteScreenState extends State<CartInviteScreen> {
  final _nameController = TextEditingController();
  final _sessionNameController = TextEditingController();
  bool _isLoading = false;
  bool _sessionCreated = false;
  String _inviteLink = '';
  int _inviteSent = 0;

  @override
  void initState() {
    super.initState();
    _sessionNameController.text = 'Shopping Session';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sessionNameController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name first'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final sessionProvider = Provider.of<SessionProvider>(
        context,
        listen: false,
      );

      // Get the current user's name
      final currentUserName = _nameController.text;

      // Create a new session with the specified name
      final sessionId = await sessionProvider.createNewSession(
        name:
            _sessionNameController.text.isEmpty
                ? 'Shopping Session'
                : _sessionNameController.text,
      );

      // Get the share URL
      final link = sessionProvider.getShareUrl();

      if (mounted) {
        // Only update the UI if the widget is still in the tree
        sessionProvider.setCurrentUserName(currentUserName);
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.setActiveSession(sessionId);
        setState(() {
          _sessionCreated = true;
          _inviteLink = link;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating session: ${error.toString()}'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _inviteLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendInvite() {
    setState(() {
      _inviteSent++;
    });

    // Simulate an email address
    final String mockEmail = 'friend$_inviteSent@gmail.com';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite sent to $mockEmail'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text(
          !_sessionCreated ? 'Create Shopping Cart' : 'Share Cart',
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kWhiteColor,
          ),
        ),
        backgroundColor: kPurpleColor,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: kPurpleColor),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_sessionCreated) ...[
                        // Session creation card with slide-in animation
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
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: kPurpleColor,
                                      ),
                                      prefixIconColor: kPurpleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _sessionNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Session Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        Icons.shopping_cart,
                                        color: kPurpleColor,
                                      ),
                                      prefixIconColor: kPurpleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Center(
                                    child: PulseAnimation(
                                      duration: const Duration(
                                        milliseconds: 2000,
                                      ),
                                      minScale: 1.0,
                                      maxScale: 1.04,
                                      child: PrimaryButton(
                                        text: 'Create Session',
                                        onPressed: _createSession,
                                        icon: Icons.add_shopping_cart,
                                        isFullWidth: true,
                                      ),
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
                        ),
                      ] else ...[
                        // Session created, show sharing options with fade-in animation
                        SlideInAnimation(
                          beginOffset: const Offset(0, 0.1),
                          duration: const Duration(milliseconds: 800),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                kCardBorderRadius,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: kFadedPurple,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: kPurpleColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hi, ${_nameController.text}!',
                                              style: kTitleTextStyle.copyWith(
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              sessionProvider
                                                      .currentSession
                                                      ?.name ??
                                                  'Shopping Session',
                                              style: kCaptionTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const StatusBadge(
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

                                  // Invite link container with slide-in animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0.1, 0),
                                    duration: const Duration(milliseconds: 600),
                                    delay: true,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: kGreyColor2),
                                        borderRadius: BorderRadius.circular(
                                          kButtonBorderRadius,
                                        ),
                                        color: Colors.grey[100],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _inviteLink,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.copy,
                                              color: kPurpleColor,
                                            ),
                                            onPressed: _copyToClipboard,
                                            tooltip: 'Copy link',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Invitation Stats with slide-in animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.1),
                                    duration: const Duration(milliseconds: 600),
                                    delay: true,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          kButtonBorderRadius,
                                        ),
                                        color: kFadedPurple,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Invitation Status',
                                            style: kTitleTextStyle.copyWith(
                                              color: kPurpleColor,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.send,
                                                    size: 16,
                                                    color: kPurpleColor,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text(
                                                    'Invitations sent:',
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '$_inviteSent',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.group,
                                                    size: 16,
                                                    color: kPurpleColor,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Text('Friends joined:'),
                                                ],
                                              ),
                                              Text(
                                                '${_inviteSent > 0 ? (_inviteSent - 1) : 0}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Button row with slide-in animation
                                  SlideInAnimation(
                                    beginOffset: const Offset(0, 0.1),
                                    duration: const Duration(milliseconds: 600),
                                    delay: true,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 48,
                                            child: SecondaryButton(
                                              text: 'Copy',
                                              onPressed: _copyToClipboard,
                                              icon: Icons.copy,
                                              isFullWidth: true,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 48,
                                            child: PrimaryButton(
                                              text: 'Invite',
                                              onPressed: _sendInvite,
                                              icon: Icons.share,
                                              isFullWidth: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Start shopping button with pulse animation
                                  PulseAnimation(
                                    duration: const Duration(
                                      milliseconds: 2000,
                                    ),
                                    minScale: 1.0,
                                    maxScale: 1.04,
                                    child: PrimaryButton(
                                      text: 'Start Shopping',
                                      onPressed: () {
                                        context.router.push(
                                          const ProductListRoute(),
                                        );
                                      },
                                      icon: Icons.shopping_bag_outlined,
                                      isFullWidth: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }
}
