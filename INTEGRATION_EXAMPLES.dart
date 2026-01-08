// Example integration for adding chat and payment features to existing screens
// Add these imports and code snippets to your screens

// ============================================================================
// EXAMPLE 1: Add Chat Button to Booking Detail Screen
// ============================================================================
/*
import 'package:ayojana_hub/chat_screen.dart';

// In your booking detail screen, add this button:
ElevatedButton.icon(
  onPressed: () async {
    final chatProvider = context.read<ChatProvider>();
    final conversationId = await chatProvider.createOrGetConversation(
      customerId: booking.customerId,
      customerName: booking.customerName,
      vendorId: booking.vendorId,
      vendorName: booking.vendorName,
      bookingId: booking.id,
    );
    
    if (conversationId != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            conversationId: conversationId,
            otherUserName: booking.vendorName,
            otherUserId: booking.vendorId,
            userRole: 'customer',
            bookingId: booking.id,
          ),
        ),
      );
    }
  },
  icon: const Icon(Icons.chat),
  label: const Text('Message Vendor'),
),
*/

// ============================================================================
// EXAMPLE 2: Add Payment Button to My Bookings Screen
// ============================================================================
/*
import 'package:ayojana_hub/payment_screen.dart';

// In your bookings list, add this for each booking:
if (booking.paymentStatus == 'pending' || booking.paymentStatus == 'failed')
  ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            booking: booking,
            onPaymentComplete: (success) {
              if (success) {
                // Refresh the bookings list
                context.read<BookingProvider>()
                    .loadMyBookings(currentUser.uid);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment successful! Booking confirmed.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade400,
      foregroundColor: Colors.white,
    ),
    child: const Text('Pay Now'),
  ),
*/

// ============================================================================
// EXAMPLE 3: Add Messages Tab to Navigation
// ============================================================================
/*
import 'package:ayojana_hub/conversations_list_screen.dart';

// Add to your bottom navigation bar item
BottomNavigationBarItem(
  icon: const Icon(Icons.chat_bubble),
  label: 'Messages',
),

// Add to navigation logic:
case 2: // or whatever index you use
  return const ConversationsListScreen();
*/

// ============================================================================
// EXAMPLE 4: Complete Booking Detail Screen Integration
// ============================================================================
/*
import 'package:ayojana_hub/booking_model.dart';
import 'package:ayojana_hub/chat_screen.dart';
import 'package:ayojana_hub/chat_provider.dart';
import 'package:ayojana_hub/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.eventName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Vendor: ${booking.vendorName}'),
                    Text('Price: ₹${booking.price}'),
                    Text('Status: ${booking.status}'),
                    Text('Payment: ${booking.paymentStatus}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // Message button
                  ElevatedButton.icon(
                    onPressed: () async {
                      final chatProvider = context.read<ChatProvider>();
                      final conversationId =
                          await chatProvider.createOrGetConversation(
                        customerId: booking.customerId,
                        customerName: booking.customerName,
                        vendorId: booking.vendorId,
                        vendorName: booking.vendorName,
                        bookingId: booking.id,
                      );

                      if (conversationId != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              conversationId: conversationId,
                              otherUserName: booking.vendorName,
                              otherUserId: booking.vendorId,
                              userRole: 'customer',
                              bookingId: booking.id,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Message Vendor'),
                  ),
                  const SizedBox(height: 8),
                  
                  // Payment button
                  if (booking.paymentStatus != 'completed')
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              booking: booking,
                              onPaymentComplete: (success) {
                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Payment Completed',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 5: Vendor Booking Response with Chat
// ============================================================================
/*
// When vendor confirms a booking:
Future<void> confirmBooking(String bookingId) async {
  final bookingProvider = context.read<BookingProvider>();
  final chatProvider = context.read<ChatProvider>();
  
  // Update booking status
  await bookingProvider.updateBookingStatus(bookingId, 'confirmed');
  
  // Create conversation for communication
  final booking = await bookingProvider.getBookingById(bookingId);
  if (booking != null) {
    await chatProvider.createOrGetConversation(
      customerId: booking.customerId,
      customerName: booking.customerName,
      vendorId: booking.vendorId,
      vendorName: booking.vendorName,
      bookingId: bookingId,
    );
    
    // Send initial message
    await chatProvider.sendMessage(
      conversationId: conversationId,
      receiverId: booking.customerId,
      receiverName: booking.customerName,
      message: 'Booking confirmed! Looking forward to working with you.',
      senderRole: 'vendor',
      bookingId: bookingId,
    );
  }
}
*/

// ============================================================================
// EXAMPLE 6: Payment with Error Handling
// ============================================================================
/*
// Complete payment flow with error handling:
Future<void> processPayment(BookingModel booking) async {
  final bookingProvider = context.read<BookingProvider>();
  
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(
        booking: booking,
        onPaymentComplete: (success) {
          if (success) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    ),
  );

  if (result == true) {
    // Refresh booking details
    final updatedBooking = await bookingProvider.getBookingById(booking.id);
    if (updatedBooking != null && updatedBooking.paymentStatus == 'completed') {
      // Navigate back or show confirmation
      Navigator.pop(context);
    }
  }
}
*/

// ============================================================================
// EXAMPLE 7: Real-time Notification Handler
// ============================================================================
/*
// Add to your app initialization or main screen:

@override
void initState() {
  super.initState();
  
  // Listen for new messages
  _listenForNewMessages();
}

void _listenForNewMessages() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;
  
  FirebaseFirestore.instance
      .collection('conversations')
      .where('customerId', isEqualTo: currentUser.uid)
      .snapshots()
      .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.modified) {
        final conversation = ConversationModel.fromMap(
          change.doc.data() as Map<String, dynamic>,
          change.doc.id,
        );
        
        if (conversation.unreadCount > 0) {
          // Show notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'New message from ${conversation.vendorName}',
              ),
              action: SnackBarAction(
                label: 'View',
                onPressed: () {
                  // Navigate to chat
                },
              ),
            ),
          );
        }
      }
    }
  });
}
*/
