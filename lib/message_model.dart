import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String receiverId;
  final String receiverName;
  final String message;
  final DateTime sentAt;
  final bool isRead;
  final String messageType; // 'text', 'image', 'document'
  final String? mediaUrl;
  final String bookingId;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.sentAt,
    required this.isRead,
    this.messageType = 'text',
    this.mediaUrl,
    required this.bookingId,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    final sentAtTimestamp = map['sentAt'] as Timestamp?;

    return MessageModel(
      id: id,
      conversationId: map['conversationId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderRole: map['senderRole'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      message: map['message'] ?? '',
      sentAt: (sentAtTimestamp ?? Timestamp.now()).toDate(),
      isRead: map['isRead'] ?? false,
      messageType: map['messageType'] ?? 'text',
      mediaUrl: map['mediaUrl'],
      bookingId: map['bookingId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'message': message,
      'sentAt': Timestamp.fromDate(sentAt),
      'isRead': isRead,
      'messageType': messageType,
      'mediaUrl': mediaUrl,
      'bookingId': bookingId,
    };
  }
}

class ConversationModel {
  final String id;
  final String customerId;
  final String customerName;
  final String vendorId;
  final String vendorName;
  final String bookingId;
  final DateTime lastMessageTime;
  final String lastMessage;
  final int unreadCount;
  final DateTime createdAt;

  ConversationModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.vendorId,
    required this.vendorName,
    required this.bookingId,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.unreadCount,
    required this.createdAt,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map, String id) {
    final lastMessageTimeTimestamp = map['lastMessageTime'] as Timestamp?;
    final createdAtTimestamp = map['createdAt'] as Timestamp?;

    return ConversationModel(
      id: id,
      customerId: map['customerId'] ?? '',
      customerName: map['customerName'] ?? '',
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      bookingId: map['bookingId'] ?? '',
      lastMessageTime: (lastMessageTimeTimestamp ?? Timestamp.now()).toDate(),
      lastMessage: map['lastMessage'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
      createdAt: (createdAtTimestamp ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'bookingId': bookingId,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
