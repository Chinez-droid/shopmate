import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'responsive_widget.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        // Adjust padding and font size based on screen size
        final verticalPadding = sizingInfo.screenSize.width < 360 ? 12.0 : 16.0;
        final horizontalPadding =
            sizingInfo.screenSize.width < 360 ? 18.0 : 24.0;
        final iconSize = sizingInfo.screenSize.width < 360 ? 16.0 : 20.0;

        final buttonTextStyle = kButtonTextStyle.copyWith(
          fontSize:
              sizingInfo.screenSize.width < 360
                  ? 14.0
                  : kButtonTextStyle.fontSize,
        );

        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurpleColor,
              foregroundColor: kWhiteColor,
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
              ),
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: CircularProgressIndicator(
                        color: kWhiteColor,
                        strokeWidth:
                            sizingInfo.screenSize.width < 360 ? 2.0 : 2.5,
                      ),
                    )
                    : icon != null
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: iconSize),
                        SizedBox(
                          width: sizingInfo.screenSize.width < 360 ? 6 : 8,
                        ),
                        Text(text, style: buttonTextStyle),
                      ],
                    )
                    : Text(text, style: buttonTextStyle),
          ),
        );
      },
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final verticalPadding = sizingInfo.screenSize.width < 360 ? 10.0 : 14.0;
        final horizontalPadding =
            sizingInfo.screenSize.width < 360 ? 16.0 : 20.0;
        final iconSize = sizingInfo.screenSize.width < 360 ? 16.0 : 18.0;

        final buttonTextStyle = kSmallButtonTextStyle.copyWith(
          fontSize:
              sizingInfo.screenSize.width < 360
                  ? 12.0
                  : kSmallButtonTextStyle.fontSize,
        );

        return SizedBox(
          width: isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: kPurpleColor,
              side: BorderSide(
                color: kPurpleColor,
                width: sizingInfo.screenSize.width < 360 ? 1.0 : 1.5,
              ),
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: horizontalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kButtonBorderRadius),
              ),
            ),
            child:
                icon != null
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: iconSize),
                        SizedBox(
                          width: sizingInfo.screenSize.width < 360 ? 6 : 8,
                        ),
                        Text(text, style: buttonTextStyle),
                      ],
                    )
                    : Text(text, style: buttonTextStyle),
          ),
        );
      },
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final bool isActive;

  const StatusBadge({super.key, required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final color = isActive ? kSuccessColor : kGreyColor1;
        final horizontalPadding =
            sizingInfo.screenSize.width < 360 ? 8.0 : 10.0;
        final verticalPadding = sizingInfo.screenSize.width < 360 ? 3.0 : 4.0;
        final fontSize = sizingInfo.screenSize.width < 360 ? 10.0 : 12.0;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              sizingInfo.screenSize.width < 360 ? 10 : 12,
            ),
            border: Border.all(color: color),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        );
      },
    );
  }
}

class SessionCard extends StatelessWidget {
  final String title;
  final String creatorName;
  final bool isActive;
  final DateTime createdAt;
  final int participantCount;
  final VoidCallback? onTap;

  const SessionCard({
    super.key,
    required this.title,
    required this.creatorName,
    required this.isActive,
    required this.createdAt,
    required this.participantCount,
    this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final iconContainerSize = isSmallScreen ? 40.0 : 48.0;
        final iconSize = isSmallScreen ? 20.0 : 24.0;
        final borderRadius = isSmallScreen ? 12.0 : 14.0;
        final padding = isSmallScreen ? 12.0 : 16.0;

        final titleStyle = kTitleTextStyle.copyWith(
          fontSize: isSmallScreen ? 14.0 : kTitleTextStyle.fontSize,
        );

        final captionStyle = kCaptionTextStyle.copyWith(
          fontSize: isSmallScreen ? 10.0 : kCaptionTextStyle.fontSize,
        );

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kCardBorderRadius),
          ),
          child: InkWell(
            onTap: isActive ? onTap : null,
            borderRadius: BorderRadius.circular(kCardBorderRadius),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: iconContainerSize,
                        height: iconContainerSize,
                        decoration: BoxDecoration(
                          color: kFadedPurple,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Icon(
                          participantCount > 0 ? Icons.people : Icons.person,
                          color: kPurpleColor,
                          size: iconSize,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: titleStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 2 : 4),
                            Text(
                              creatorName.startsWith('Created')
                                  ? creatorName
                                  : 'Created by $creatorName',
                              style: captionStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          StatusBadge(
                            text: isActive ? 'Active' : 'Completed',
                            isActive: isActive,
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 8),
                          Text(_formatDate(createdAt), style: captionStyle),
                        ],
                      ),
                      if (participantCount > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.group,
                              size: isSmallScreen ? 14 : 16,
                              color: kGreyColor1,
                            ),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              '$participantCount ${participantCount == 1 ? 'friend' : 'friends'}',
                              style: captionStyle,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final iconSize = isSmallScreen ? 60.0 : 72.0;
        final padding = isSmallScreen ? 24.0 : 32.0;

        final messageStyle = kBodyTextStyle.copyWith(
          color: kGreyColor1,
          fontStyle: FontStyle.italic,
          fontSize: isSmallScreen ? 14.0 : kBodyTextStyle.fontSize,
        );

        return Center(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: kGreyColor2),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(message, textAlign: TextAlign.center, style: messageStyle),
                if (actionText != null && onAction != null) ...[
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  SecondaryButton(
                    text: actionText!,
                    onPressed: onAction!,
                    icon: Icons.add,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final isSmallScreen = sizingInfo.screenSize.width < 360;
        final verticalPadding = isSmallScreen ? 12.0 : 16.0;

        final titleStyle = kTitleTextStyle.copyWith(
          fontSize: isSmallScreen ? 16.0 : kTitleTextStyle.fontSize,
        );

        final actionStyle = kSmallButtonTextStyle.copyWith(
          fontSize: isSmallScreen ? 10.0 : 12.0,
        );

        return Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: titleStyle),
              if (actionText != null && onAction != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(actionText!, style: actionStyle),
                ),
            ],
          ),
        );
      },
    );
  }
}
