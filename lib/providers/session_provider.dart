import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';
import '../models/session.dart';

class SessionProvider with ChangeNotifier {
  ShoppingSession? _currentSession;
  final List<ShoppingSession> _pastSessions = [];
  String _currentUserName = '';
  bool _isCreator = true;
  final Faker _faker = Faker();

  ShoppingSession? get currentSession => _currentSession;
  List<ShoppingSession> get pastSessions => [..._pastSessions];
  String get currentUserName => _currentUserName;
  bool get isCreator => _isCreator;

  void setCurrentUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }

  String createNewSession() {
    if (_currentUserName.isEmpty) {
      throw Exception('User name is required');
    }
    
    final uuid = const Uuid();
    final sessionId = uuid.v4();
    
    _currentSession = ShoppingSession(
      sessionId: sessionId,
      creatorName: _currentUserName,
    );
    
    _isCreator = true;
    notifyListeners();
    return sessionId;
  }

  bool joinSession(String sessionId, String friendName) {
    // In a real app, you would verify the session exists in a database
    // For this demo, we'll simulate a session with a randomly generated creator name
    final creatorName = _faker.person.firstName();
    
    _currentSession = ShoppingSession(
      sessionId: sessionId,
      creatorName: creatorName,
      friendName: friendName,
    );
    
    _currentUserName = friendName;
    _isCreator = false;
    notifyListeners();
    return true;
  }

  void leaveSession() {
    if (_currentSession != null) {
      _currentSession!.isActive = false;
      _pastSessions.add(_currentSession!);
      _currentSession = null;
    }
    notifyListeners();
  }

  // Simulate session sharing - returns share URL
  String getShareUrl() {
    if (_currentSession == null) {
      throw Exception('No active session');
    }
    return 'app://shop/session/${_currentSession!.sessionId}';
  }
  
  // Add mock past sessions for the home screen using Faker
  List<ShoppingSession> getMockSessions() {
    final List<ShoppingSession> mockSessions = [];
    
    // Generate 3-5 random mock sessions
    final sessionCount = 3 + _faker.randomGenerator.integer(3); // 3 to 5 sessions
    
    for (int i = 0; i < sessionCount; i++) {
      final bool isActive = _faker.randomGenerator.boolean();
      final bool hasFriend = _faker.randomGenerator.boolean();
      final String sessionName = _generateSessionName();
      
      mockSessions.add(ShoppingSession(
        sessionId: const Uuid().v4(),
        creatorName: _currentUserName.isEmpty ? _faker.person.firstName() : _currentUserName,
        friendName: hasFriend ? _faker.person.firstName() : null,
        isActive: isActive,
        createdAt: DateTime.now().subtract(Duration(
          days: _faker.randomGenerator.integer(7),
          hours: _faker.randomGenerator.integer(24),
        )),
        name: sessionName, // Use the sessionName variable here
      ));
    }
    
    return mockSessions;
  }
  
  // Helper to generate realistic shopping session names
  String _generateSessionName() {
    final sessionTypes = [
      'Grocery Shopping',
      'Weekly Shopping',
      'Birthday Gift',
      'Home Essentials',
      'Office Supplies',
      'Weekend Supplies',
      'Party Shopping',
      'Holiday Shopping',
      'Back to School',
      'Tech Gadgets'
    ];
    
    return sessionTypes[_faker.randomGenerator.integer(sessionTypes.length)];
  }
}