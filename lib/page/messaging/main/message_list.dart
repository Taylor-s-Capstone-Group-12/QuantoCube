import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.chatList,
    this.isFirstTime,
  });

  final List<Map<String, dynamic>> chatList;
  final bool? isFirstTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView.builder(
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

          DateTime messageDate = message['date'];
          String formattedDate = DateFormat('MMMM d, yyyy').format(messageDate);

          bool showDateHeader = adjustedIndex == 0 ||
              DateFormat('yyyy-MM-dd')
                      .format(chatList[adjustedIndex - 1]['date']) !=
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
              _buildMessageItem(message),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'message':
        return MessageBubble(
          message: message['message'] ?? 'ERROR',
          isSender: bool.parse(message['isSender'] ?? 'true'),
          date: message['date'],
        );
      case 'attachment':
        return AttachmentBubble(
          message: message['message'] ?? 'ERROR',
          isSender: bool.parse(message['isSender'] ?? 'true'),
          onTap: message['onTap'] as VoidCallback,
          date: message['date'],
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
              left: isSender ? 0 : 10, right: isSender ? 10 : 0),
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
              left: isSender ? 0 : 10, right: isSender ? 10 : 0),
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
