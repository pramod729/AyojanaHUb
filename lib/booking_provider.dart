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
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('customerId', isEqualTo: customerId)
          .get();

      final bookingsList = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();

      bookingsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _bookings = bookingsList;
    } catch (e) {
      _error = 'Failed to load bookings: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadVendorBookings(String vendorId) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('vendorId', isEqualTo: vendorId)
          .get();

      final bookingsList = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();

      bookingsList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _bookings = bookingsList;
    } catch (e) {
      _error = 'Failed to load vendor bookings: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
      return null;
    } catch (e) {
      return 'Failed to create booking: $e';
    }
  }

  Future<String?> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'Failed to update booking status: $e';
    }
  }

  Future<String?> cancelBooking(String bookingId) async {
    return updateBookingStatus(bookingId, 'cancelled');
  }
}
