import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            switch (chatList[index]['type']) {
              case 'message':
                return MessageBubble(
                  message: chatList[index]['message'] ?? 'ERROR',
                  isSender: bool.parse(chatList[index]['isSender'] ?? 'true'),
                  date: chatList[index]['date'],
                );
              case 'attachment':
                return AttachmentBubble(
                  message: chatList[index]['message'] ?? 'ERROR',
                  isSender: bool.parse(chatList[index]['isSender'] ?? 'true'),
                  onTap: chatList[index]['onTap'] as VoidCallback,
                  date: chatList[index]['date'],
                );
              default:
                return const SizedBox();
            }
          }),
    );
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
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF2C2C2C),
            ),
            child: Text(message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                )),
          ),
          DateDivider(date: _formatChatTime(date)),
        ],
      ),
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
  });

  final String message;
  final bool isSender;
  final VoidCallback onTap;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFF2C2C2C),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: const CircleAvatar(
                        radius: 15,
                        child: Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
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
          DateDivider(date: _formatChatTime(date)),
        ],
      ),
    );
  }
}

String _formatChatTime(DateTime messageTime) {
  Duration difference = DateTime.now().difference(messageTime);

  if (difference.inSeconds < 60) {
    return "${difference.inSeconds} s"; // Seconds ago
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} mins"; // Minutes ago
  } else if (difference.inHours < 24) {
    return "${difference.inHours} hrs"; // Hours ago
  } else {
    return "${messageTime.day} ${_getMonthName(messageTime.month)}"; // "18 Mar"
  }
}

String _getMonthName(int month) {
  const months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month];
}
