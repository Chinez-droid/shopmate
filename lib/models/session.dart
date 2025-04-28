// Updated ShoppingSession class
class ShoppingSession {
  final String sessionId;
  final String creatorName;
  List<String> participants; // Replace friendName with a list of participants
  bool isActive;
  DateTime createdAt;
  String name;

  ShoppingSession({
    required this.sessionId,
    required this.creatorName,
    List<String>? participants, // Optional list of participants
    this.isActive = true,
    DateTime? createdAt,
    this.name = 'Shopping Session',
  }) : 
    participants = participants ?? [], // Initialize empty list if not provided
    createdAt = createdAt ?? DateTime.now();
}