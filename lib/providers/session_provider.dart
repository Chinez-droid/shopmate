import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/session.dart';

class SessionProvider with ChangeNotifier {
  ShoppingSession? _currentSession;
  final List<ShoppingSession> _pastSessions = [];
  String _currentUserName = '';
  bool _isCreator = true;

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
    // For this demo, we'll simulate a valid join
    _currentSession = ShoppingSession(
      sessionId: sessionId,
      creatorName: 'Original Creator', // In a real app, fetch this
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
}