class ShoppingSession {
  final String sessionId;
  final String creatorName;
  String? friendName;
  bool isActive;
  DateTime createdAt;
  String name; // Added name property

  ShoppingSession({
    required this.sessionId,
    required this.creatorName,
    this.friendName,
    this.isActive = true,
    DateTime? createdAt,
    this.name = 'Shopping Session', // Default value
  }) : createdAt = createdAt ?? DateTime.now();
}