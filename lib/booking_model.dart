import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String eventId;
  final String eventName;
  final String customerId;
  final String customerName;
  final String vendorId;
  final String vendorName;
  final String proposalId;
  final int guestCount;
  final String eventType;
  final String vendorCategory;
  final double price;
  final DateTime bookingDate;
  final DateTime eventDate;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final String paymentStatus;
  final String? orderId;
  final String? transactionId;
  final String paymentMethod;
  final DateTime? paymentDate;
  final String? paymentError;

  BookingModel({
    required this.id,
    this.eventId = '',
    this.eventName = '',
    required this.customerId,
    required this.customerName,
    required this.vendorId,
    required this.vendorName,
    this.proposalId = '',
    this.guestCount = 0,
    this.eventType = '',
    required this.vendorCategory,
    required this.price,
    required this.bookingDate,
    required this.eventDate,
    required this.status,
    this.notes,
    required this.createdAt,
    this.paymentStatus = 'pending',
    this.orderId,
    this.transactionId,
    this.paymentMethod = 'razorpay',
    this.paymentDate,
    this.paymentError,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    final bookingTimestamp = map['bookingDate'] as Timestamp?;
    final eventTimestamp = map['eventDate'] as Timestamp?;
    final createdAtTimestamp = map['createdAt'] as Timestamp?;
    final paymentDateTimestamp = map['paymentDate'] as Timestamp?;

    return BookingModel(
      id: id,
      eventId: map['eventId'] ?? '',
      eventName: map['eventName'] ?? '',
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      proposalId: map['proposalId'] ?? '',
      guestCount: (map['guestCount'] ?? 0) as int,
      eventType: map['eventType'] ?? '',
      vendorCategory: map['vendorCategory'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      bookingDate: (bookingTimestamp ?? Timestamp.now()).toDate(),
      eventDate: (eventTimestamp ?? Timestamp.now()).toDate(),
      status: map['status'] ?? 'confirmed',
      notes: map['notes'],
      createdAt: (createdAtTimestamp ?? Timestamp.now()).toDate(),
      paymentStatus: map['paymentStatus'] ?? 'pending',
      orderId: map['orderId'],
      transactionId: map['transactionId'],
      paymentMethod: map['paymentMethod'] ?? 'razorpay',
      paymentDate: paymentDateTimestamp?.toDate(),
      paymentError: map['paymentError'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'customerId': customerId,
      'customerName': customerName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'proposalId': proposalId,
      'guestCount': guestCount,
      'eventType': eventType,
      'vendorCategory': vendorCategory,
      'price': price,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'eventDate': Timestamp.fromDate(eventDate),
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'paymentStatus': paymentStatus,
      'orderId': orderId,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'paymentDate': paymentDate != null ? Timestamp.fromDate(paymentDate!) : null,
      'paymentError': paymentError,
    };
  }
}
