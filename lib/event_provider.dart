import 'package:ayojana_hub/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMyEvents(String userId) async {
    if (_isLoading) return; // Prevent multiple simultaneous loads
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _events = snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data(), doc.id))
          .toList();
      print('Loaded ${_events.length} events');
    } catch (e) {
      print('Error loading events: $e');
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> createEvent(EventModel event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
      return null;
    } catch (e) {
      print('Error creating event: $e');
      return 'Failed to create event: $e';
    }
  }

  Future<String?> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('events').doc(eventId).update(data);
      return null;
    } catch (e) {
      print('Error updating event: $e');
      return 'Failed to update event';
    }
  }

  Future<String?> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
      return null;
    } catch (e) {
      return 'Failed to delete event';
    }
  }
}