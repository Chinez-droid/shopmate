import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:faker/faker.dart';
import '../models/session.dart';
import '../services/firestore_service.dart';

class SessionProvider with ChangeNotifier {
  ShoppingSession? _currentSession;
  List<ShoppingSession> _pastSessions = [];
  String _currentUserName = '';
  bool _isCreator = true;
  final Faker _faker = Faker();
  final FirestoreService _firestoreService = FirestoreService();

  ShoppingSession? get currentSession => _currentSession;
  List<ShoppingSession> get pastSessions => [..._pastSessions];
  String get currentUserName => _currentUserName;
  bool get isCreator => _isCreator;

  // Set current user name
  void setCurrentUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }

  // Create a new shopping session in Firestore
  Future<String> createNewSession({String? name}) async {
    if (_currentUserName.isEmpty) {
      throw Exception('User name is required');
    }

    final uuid = const Uuid();
    final sessionId = uuid.v4();

    final newSession = ShoppingSession(
      sessionId: sessionId,
      creatorName: _currentUserName,
      participants: [],
      name: name ?? 'Shopping Session',
      isActive: true,
      createdAt: DateTime.now(),
    );

    try {
      final createdSessionId = await _firestoreService.createSession(
        newSession,
      );

      _currentSession = newSession.copyWith(sessionId: createdSessionId);
      _isCreator = true;
      notifyListeners();

      return createdSessionId;
    } catch (e) {
      debugPrint('Error creating session: $e');
      throw Exception('Failed to create shopping session');
    }
  }

  // Join an existing session
  Future<bool> joinSession(String sessionId, String participantName) async {
    try {
      // Get session from Firestore
      final session = await _firestoreService.getSession(sessionId);

      if (session == null) {
        return false;
      }

      // Add the participant to the session in Firestore
      final success = await _firestoreService.addParticipantToSession(
        sessionId,
        participantName,
      );

      if (success) {
        // Update local session state
        session.participants.add(participantName);
        _currentSession = session;
        _currentUserName = participantName;
        _isCreator = false;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error joining session: $e');
      return false;
    }
  }

  // Add a participant to current session
  Future<bool> addParticipant(String participantName) async {
    if (_currentSession == null) {
      return false;
    }

    try {
      // Check if participant already exists
      if (!_currentSession!.participants.contains(participantName)) {
        final success = await _firestoreService.addParticipantToSession(
          _currentSession!.sessionId,
          participantName,
        );

        if (success) {
          _currentSession!.participants.add(participantName);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error adding participant: $e');
      return false;
    }
  }

  // Get all participants including the creator
  List<String> getAllParticipants() {
    if (_currentSession == null) {
      return [];
    }
    return [_currentSession!.creatorName, ..._currentSession!.participants];
  }

  int getParticipantCount() {
    if (_currentSession == null) {
      return 0;
    }

    // Creator + participants
    return 1 + _currentSession!.participants.length;
  }

  // Leave or end current session
  Future<void> leaveSession() async {
    if (_currentSession != null) {
      try {
        // Update session status in Firestore if you're the creator
        if (_isCreator) {
          await _firestoreService.updateSessionStatus(
            _currentSession!.sessionId,
            false,
          );
        }

        // Add to past sessions
        _currentSession!.isActive = false;
        _pastSessions.add(_currentSession!);
        _currentSession = null;
        notifyListeners();
      } catch (e) {
        debugPrint('Error leaving session: $e');
        throw Exception('Failed to leave session');
      }
    }
  }

  // Get past sessions for current user
  Future<void> loadUserSessions() async {
    if (_currentUserName.isEmpty) {
      return;
    }

    try {
      _pastSessions = await _firestoreService.getUserSessions(_currentUserName);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user sessions: $e');
    }
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
    final sessionCount = 3 + _faker.randomGenerator.integer(3);

    for (int i = 0; i < sessionCount; i++) {
      final bool isActive = _faker.randomGenerator.boolean();
      final String sessionName = _generateSessionName();

      // Generate 0-3 random participants
      final int participantCount = _faker.randomGenerator.integer(4); // 0 to 3
      List<String> participants = [];

      for (int j = 0; j < participantCount; j++) {
        participants.add(_faker.person.firstName());
      }

      mockSessions.add(
        ShoppingSession(
          sessionId: const Uuid().v4(),
          creatorName:
              _currentUserName.isEmpty
                  ? _faker.person.firstName()
                  : _currentUserName,
          participants: participants,
          isActive: isActive,
          createdAt: DateTime.now().subtract(
            Duration(
              days: _faker.randomGenerator.integer(7),
              hours: _faker.randomGenerator.integer(24),
            ),
          ),
          name: sessionName,
        ),
      );
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
      'Tech Gadgets',
    ];

    return sessionTypes[_faker.randomGenerator.integer(sessionTypes.length)];
  }
}
