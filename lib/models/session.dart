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
  }) : participants =
           participants ?? [], // Initialize empty list if not provided
       createdAt = createdAt ?? DateTime.now();

  // Add copyWith method to create a copy with some properties changed
  ShoppingSession copyWith({
    String? sessionId,
    String? creatorName,
    List<String>? participants,
    bool? isActive,
    DateTime? createdAt,
    String? name,
  }) {
    return ShoppingSession(
      sessionId: sessionId ?? this.sessionId,
      creatorName: creatorName ?? this.creatorName,
      participants: participants ?? this.participants,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
    );
  }
}
