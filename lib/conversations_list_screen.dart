import 'package:ayojana_hub/chat_provider.dart';
import 'package:ayojana_hub/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        context.read<ChatProvider>().loadConversations(currentUser.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${chatProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        chatProvider.loadConversations(currentUser.uid);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (chatProvider.conversations.isEmpty) {
            return const Center(
              child: Text('No conversations yet'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser != null) {
                await chatProvider.loadConversations(currentUser.uid);
              }
            },
            child: ListView.separated(
              itemCount: chatProvider.conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
              itemBuilder: (context, index) {
                final conversation = chatProvider.conversations[index];
                final currentUser = FirebaseAuth.instance.currentUser;
                final otherUserName = currentUser?.uid == conversation.customerId
                    ? conversation.vendorName
                    : conversation.customerName;
                final otherUserId = currentUser?.uid == conversation.customerId
                    ? conversation.vendorId
                    : conversation.customerId;

                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          conversationId: conversation.id,
                          otherUserName: otherUserName,
                          otherUserId: otherUserId,
                          userRole: currentUser?.uid == conversation.customerId
                              ? 'customer'
                              : 'vendor',
                          bookingId: conversation.bookingId,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade400,
                    child: Text(
                      otherUserName.isNotEmpty
                          ? otherUserName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(otherUserName),
                  subtitle: Text(
                    conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(conversation.lastMessageTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
