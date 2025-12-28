import 'package:ayojana_hub/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMyBookings(String customerId) async {
    if (_isLoading) return; // Prevent multiple simultaneous loads
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      _bookings = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
      print('Loaded ${_bookings.length} bookings');
    } catch (e) {
      print('Error loading bookings: $e');
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
      return null;
    } catch (e) {
      print('Error creating booking: $e');
      return 'Failed to create booking: $e';
    }
  }

  Future<String?> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
      });
      return null;
    } catch (e) {
      print('Error cancelling booking: $e');
      return 'Failed to cancel booking: $e';
    }
  }
}
