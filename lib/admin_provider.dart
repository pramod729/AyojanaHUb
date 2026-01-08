import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  int _vendorSignups = 0;
  int _totalBookings = 0;
  int _completedBookings = 0;
  double _totalRevenue = 0.0;
  String? _error;

  bool get isLoading => _isLoading;
  int get vendorSignups => _vendorSignups;
  int get totalBookings => _totalBookings;
  int get completedBookings => _completedBookings;
  double get totalRevenue => _totalRevenue;
  String? get error => _error;

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Vendor signups based on users.role
      final vendorsSnapshot = await _firestore.collection('users').where('role', isEqualTo: 'vendor').get();
      _vendorSignups = vendorsSnapshot.docs.length;

      // Bookings
      final bookingsSnapshot = await _firestore.collection('bookings').get();
      _totalBookings = bookingsSnapshot.docs.length;

      final completedSnapshot = await _firestore.collection('bookings').where('paymentStatus', isEqualTo: 'completed').get();
      _completedBookings = completedSnapshot.docs.length;

      // Revenue from payments collection if present
      double revenue = 0.0;
      try {
        final paymentsSnapshot = await _firestore.collection('payments').where('status', isEqualTo: 'completed').get();
        for (var doc in paymentsSnapshot.docs) {
          final data = doc.data();
          final amt = data['amount'];
          if (amt is num) revenue += amt.toDouble();
        }
      } catch (_) {
        // fallback: sum prices on completed bookings
        for (var doc in completedSnapshot.docs) {
          final data = doc.data();
          final price = data['price'];
          if (price is num) revenue += price.toDouble();
        }
      }

      _totalRevenue = revenue;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
