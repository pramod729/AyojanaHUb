import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();

  factory PaymentService() {
    return _instance;
  }

  PaymentService._internal();

  late Razorpay _razorpay;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Razorpay credentials - Replace with your actual keys
  static const String RAZORPAY_KEY_ID = 'rzp_live_YOUR_KEY_ID';
  // Note: Never store secret key in app - it should be on backend only

  void Function(PaymentFailureResponse)? onPaymentFailure;
  void Function(PaymentSuccessResponse)? onPaymentSuccess;
  void Function(ExternalWalletResponse)? onExternalWallet;

  void initializePayment({
    required Function(PaymentFailureResponse) onFailure,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    _razorpay = Razorpay();
    onPaymentFailure = onFailure;
    onPaymentSuccess = onSuccess;
    onExternalWallet = onWallet;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> startPayment({
    required String bookingId,
    required String customerId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required double amount,
    required String eventName,
  }) async {
    try {
      if (RAZORPAY_KEY_ID == 'rzp_live_YOUR_KEY_ID') {
        throw Exception(
            'Please configure your Razorpay Key ID in PaymentService');
      }

      var options = {
        'key': RAZORPAY_KEY_ID,
        'amount': (amount * 100).toInt(), // Amount in paise
        'currency': 'INR',
        'name': 'Ayojana Hub',
        'description': 'Booking Payment for $eventName',
        'order_id': '', // Generate from backend in production
        'prefill': {
          'contact': customerPhone,
          'email': customerEmail,
          'name': customerName,
        },
        'external': {
          'wallets': ['paytm']
        },
        'notes': {
          'bookingId': bookingId,
          'customerId': customerId,
        }
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error starting payment: $e');
      // PaymentFailureResponse expects positional args in current package version
      onPaymentFailure?.call(PaymentFailureResponse(-1, e.toString(), null));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    onPaymentSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.message}');
    onPaymentFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    onExternalWallet?.call(response);
  }

  Future<bool> recordPayment({
    required String bookingId,
    required String transactionId,
    required String orderId,
    required double amount,
  }) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'paymentStatus': 'completed',
        'transactionId': transactionId,
        'orderId': orderId,
        'paymentDate': Timestamp.now(),
        'status': 'confirmed',
      });

      // Create payment record
      await _firestore.collection('payments').add({
        'bookingId': bookingId,
        'transactionId': transactionId,
        'orderId': orderId,
        'amount': amount,
        'paymentMethod': 'razorpay',
        'status': 'completed',
        'paymentDate': Timestamp.now(),
      });

      return true;
    } catch (e) {
      debugPrint('Error recording payment: $e');
      return false;
    }
  }

  Future<bool> recordPaymentFailure({
    required String bookingId,
    required String errorMessage,
  }) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'paymentStatus': 'failed',
        'paymentError': errorMessage,
      });

      return true;
    } catch (e) {
      debugPrint('Error recording payment failure: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getPaymentStatus(String bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (doc.exists) {
        return {
          'paymentStatus': doc['paymentStatus'],
          'transactionId': doc['transactionId'],
          'orderId': doc['orderId'],
          'paymentDate': doc['paymentDate'],
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error getting payment status: $e');
      return null;
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
