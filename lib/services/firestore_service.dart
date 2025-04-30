import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/session.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  final CollectionReference _sessionsCollection;
  final CollectionReference _cartsCollection;

  FirestoreService()
    : _sessionsCollection = FirebaseFirestore.instance.collection('sessions'),
      _cartsCollection = FirebaseFirestore.instance.collection('carts');

  // Creates a new shopping session in Firestore
  Future<String> createSession(ShoppingSession session) async {
    try {
      // If a sessionId is already provided, use it, otherwise Firestore will generate one
      DocumentReference docRef;

      if (session.sessionId.isNotEmpty) {
        // Use existing sessionId
        docRef = _sessionsCollection.doc(session.sessionId);
        await docRef.set({
          'creatorName': session.creatorName,
          'isActive': session.isActive,
          'createdAt': session.createdAt,
          'name': session.name,
          'participants': session.participants,
        });
      } else {
        // Let Firestore generate an ID
        docRef = await _sessionsCollection.add({
          'creatorName': session.creatorName,
          'isActive': session.isActive,
          'createdAt': session.createdAt,
          'name': session.name,
          'participants': session.participants,
        });
      }

      // Create an empty cart document with the same ID
      await _cartsCollection.doc(docRef.id).set({
        'items': [],
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      debugPrint('Error creating session: $e');
      throw Exception('Failed to create shopping session');
    }
  }

  // Get session by ID
  Future<ShoppingSession?> getSession(String sessionId) async {
    try {
      final DocumentSnapshot sessionDoc =
          await _sessionsCollection.doc(sessionId).get();

      if (sessionDoc.exists) {
        final data = sessionDoc.data() as Map<String, dynamic>;
        return ShoppingSession(
          sessionId: sessionDoc.id,
          creatorName: data['creatorName'] ?? '',
          participants: List<String>.from(data['participants'] ?? []),
          isActive: data['isActive'] ?? true,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
          name: data['name'],
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting session: $e');
      return null;
    }
  }

  // Add participant to session
  Future<bool> addParticipantToSession(
    String sessionId,
    String participantName,
  ) async {
    try {
      await _sessionsCollection.doc(sessionId).update({
        'participants': FieldValue.arrayUnion([participantName]),
      });
      return true;
    } catch (e) {
      debugPrint('Error adding participant: $e');
      return false;
    }
  }

  // Update session status
  Future<void> updateSessionStatus(String sessionId, bool isActive) async {
    try {
      await _sessionsCollection.doc(sessionId).update({'isActive': isActive});
    } catch (e) {
      debugPrint('Error updating session status: $e');
      throw Exception('Failed to update session status');
    }
  }

  // Get all items in a cart
  Stream<Map<String, CartItem>> getCartItems(String sessionId) {
    return _cartsCollection.doc(sessionId).collection('items').snapshots().map((
      snapshot,
    ) {
      final Map<String, CartItem> items = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        items[doc.id] = CartItem(
          productId: data['productId'] ?? '',
          productName: data['productName'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          quantity: data['quantity'] ?? 1,
          addedBy: data['addedBy'] ?? '',
        );
      }
      return items;
    });
  }

  // Add item to cart
  Future<void> addItemToCart(
    String sessionId,
    String cartItemKey,
    CartItem item,
  ) async {
    try {
      await _cartsCollection
          .doc(sessionId)
          .collection('items')
          .doc(cartItemKey)
          .set({
            'productId': item.productId,
            'productName': item.productName,
            'price': item.price,
            'quantity': item.quantity,
            'addedBy': item.addedBy,
            'addedAt': FieldValue.serverTimestamp(),
          });

      // Update lastUpdated timestamp in the cart document
      await _cartsCollection.doc(sessionId).update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
      throw Exception('Failed to add item to cart');
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(
    String sessionId,
    String cartItemKey,
    int quantity,
  ) async {
    try {
      await _cartsCollection
          .doc(sessionId)
          .collection('items')
          .doc(cartItemKey)
          .update({'quantity': quantity});

      // Update lastUpdated timestamp
      await _cartsCollection.doc(sessionId).update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating item quantity: $e');
      throw Exception('Failed to update item quantity');
    }
  }

  // Clear all items from cart
  Future<void> clearCart(String sessionId) async {
    try {
      final cartItems =
          await _cartsCollection.doc(sessionId).collection('items').get();

      final batch = _firestore.batch();
      for (var doc in cartItems.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Update lastUpdated timestamp
      await _cartsCollection.doc(sessionId).update({
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error clearing cart: $e');
      throw Exception('Failed to clear cart');
    }
  }

  // Get recent sessions for a user (creator or participant)
  Future<List<ShoppingSession>> getUserSessions(String userName) async {
    try {
      // Query where user is creator
      final creatorQuery =
          await _sessionsCollection
              .where('creatorName', isEqualTo: userName)
              .orderBy('createdAt', descending: true)
              .get();

      // Query where user is participant
      final participantQuery =
          await _sessionsCollection
              .where('participants', arrayContains: userName)
              .orderBy('createdAt', descending: true)
              .get();

      final List<ShoppingSession> sessions = [];

      // Process creator sessions
      for (var doc in creatorQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        sessions.add(
          ShoppingSession(
            sessionId: doc.id,
            creatorName: data['creatorName'] ?? '',
            participants: List<String>.from(data['participants'] ?? []),
            isActive: data['isActive'] ?? true,
            createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
            name: data['name'],
          ),
        );
      }

      // Process participant sessions
      for (var doc in participantQuery.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Check if this session is already added (to prevent duplicates)
        if (!sessions.any((s) => s.sessionId == doc.id)) {
          sessions.add(
            ShoppingSession(
              sessionId: doc.id,
              creatorName: data['creatorName'] ?? '',
              participants: List<String>.from(data['participants'] ?? []),
              isActive: data['isActive'] ?? true,
              createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
              name: data['name'],
            ),
          );
        }
      }

      return sessions;
    } catch (e) {
      debugPrint('Error getting user sessions: $e');
      return [];
    }
  }
}
