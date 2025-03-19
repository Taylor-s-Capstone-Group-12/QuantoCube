import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatList,
    this.isFirstTime,
    required this.userId,
    required this.controller,
  });

  final List<Map<String, dynamic>> chatList;
  final bool? isFirstTime;
  final String userId;
  final ScrollController controller;

  bool isSender(int index) {
    if (userId == chatList[index]['sender']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
        controller: controller,
        itemCount: chatList.length + (isFirstTime == true ? 1 : 0),
        itemBuilder: (context, index) {
          if (isFirstTime == true && index == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "⚠ Be cautious of phishing and scams.",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Adjust index if first-time warning is shown
          final adjustedIndex = isFirstTime == true ? index - 1 : index;
          final message = chatList[adjustedIndex];

          // Ensure timestamp conversion
          DateTime messageDate = message['time'] is Timestamp
              ? (message['time'] as Timestamp).toDate()
              : message['time'];

          String formattedDate = DateFormat('MMMM d, yyyy').format(messageDate);

          // ✅ Ensure chatList is sorted before checking previous messages
          chatList.sort((a, b) {
            DateTime timeA = a['time'] is Timestamp
                ? (a['time'] as Timestamp).toDate()
                : a['time'];
            DateTime timeB = b['time'] is Timestamp
                ? (b['time'] as Timestamp).toDate()
                : b['time'];
            return timeA.compareTo(timeB);
          });

          bool showDateHeader = adjustedIndex == 0 ||
              DateFormat('yyyy-MM-dd').format(
                      chatList[adjustedIndex - 1]['time'] is Timestamp
                          ? (chatList[adjustedIndex - 1]['time'] as Timestamp)
                              .toDate()
                          : chatList[adjustedIndex - 1]['time']) !=
                  DateFormat('yyyy-MM-dd').format(messageDate);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateHeader)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      formattedDate.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8F9193),
                      ),
                    ),
                  ),
                ),
              _buildMessageItem(message, adjustedIndex),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, int index) {
    // Convert Firestore Timestamp to DateTime safely, handling null values
    // DateTime messageDate = message['time'] is Timestamp
    //     ? (message['time'] as Timestamp).toDate()
    //     : DateTime
    //         .now(); // Fallback if Firestore hasn't assigned a timestamp yet

    DateTime messageDate = message['time'].toLocal() ?? DateTime.now();

    print('message type: ${message['type']}');

    switch (message['type']) {
      case 'message':
        return MessageBubble(
          message: message['message'] ?? 'ERROR',
          isSender: isSender(index),
          date: messageDate,
        );
      case 'attachment':
        return AttachmentBubble(
          message: message['message'] ?? 'ERROR',
          isSender: isSender(index),
          onTap: message['onTap'] as VoidCallback,
          date: messageDate,
          attachmentType: message['attachmentType'] ?? 'Attachment',
        );
      case 'announcement':
        print('Announcement');
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              message['message'] ?? 'ERROR',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8F9193),
              ),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.date,
  });

  final String message;
  final bool isSender;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: EdgeInsets.only(
              left: isSender ? 0 : 10, right: isSender ? 10 : 0, bottom: 5),
          child: Text(
            _formatChatTime(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}

class DateDivider extends StatelessWidget {
  const DateDivider({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        date,
        style: const TextStyle(
          color: Color(0xFF8F9193),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class AttachmentBubble extends StatelessWidget {
  const AttachmentBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.onTap,
    required this.date,
    this.attachmentType = 'Service Request',
  });

  final String message;
  final String attachmentType;
  final bool isSender;
  final VoidCallback onTap;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: isSender
                            ? const Color(0xFF1B1B1B)
                            : const Color(0xFF2C2C2C),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        attachmentType,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: EdgeInsets.only(
              left: isSender ? 0 : 10, right: isSender ? 10 : 0, bottom: 5),
          child: Text(
            _formatChatTime(date),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}

String _formatChatTime(DateTime messageTime) {
  return DateFormat('HH:mm').format(messageTime); // 24-hour format
}
