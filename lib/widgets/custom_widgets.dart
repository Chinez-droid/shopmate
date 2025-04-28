import 'package:flutter/material.dart';
import '../utils/constants.dart';

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
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurpleColor,
          foregroundColor: kWhiteColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonBorderRadius),
          ),
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: kWhiteColor,
                    strokeWidth: 2.5,
                  ),
                )
                : icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(text, style: kButtonTextStyle),
                  ],
                )
                : Text(text, style: kButtonTextStyle),
      ),
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
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: kPurpleColor,
          side: const BorderSide(color: kPurpleColor, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kButtonBorderRadius),
          ),
        ),
        child:
            icon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                    Text(text, style: kSmallButtonTextStyle),
                  ],
                )
                : Text(text, style: kSmallButtonTextStyle),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final bool isActive;

  const StatusBadge({super.key, required this.text, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? kSuccessColor : kGreyColor1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class SessionCard extends StatelessWidget {
  final String title;
  final String creatorName;
  final bool isActive;
  final DateTime createdAt;
  final int participantCount;
  final VoidCallback onTap;

  const SessionCard({
    super.key,
    required this.title,
    required this.creatorName,
    required this.isActive,
    required this.createdAt,
    required this.participantCount,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
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
                          title,
                          style: kTitleTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          creatorName.startsWith('Created')
                              ? creatorName
                              : 'Created by $creatorName',
                          style: kCaptionTextStyle,
                        ),
                      ],
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: kFadedPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        color: kPurpleColor,
                        onPressed: onTap,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      StatusBadge(
                        text: isActive ? 'Active' : 'Completed',
                        isActive: isActive,
                      ),
                      const SizedBox(width: 8),
                      Text(_formatDate(createdAt), style: kCaptionTextStyle),
                    ],
                  ),
                  if (participantCount > 0)
                    Row(
                      children: [
                        Icon(Icons.group, size: 16, color: kGreyColor1),
                        const SizedBox(width: 4),
                        Text(
                          '$participantCount ${participantCount == 1 ? 'friend' : 'friends'}',
                          style: kCaptionTextStyle,
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: kGreyColor2),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: kBodyTextStyle.copyWith(
                color: kGreyColor1,
                fontStyle: FontStyle.italic,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kTitleTextStyle),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: kSmallButtonTextStyle.copyWith(fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}