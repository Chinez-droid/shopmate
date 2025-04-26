class ShoppingSession {
  final String sessionId;
  final String creatorName;
  String? friendName;
  bool isActive;
  DateTime createdAt;

  ShoppingSession({
    required this.sessionId,
    required this.creatorName,
    this.friendName,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}