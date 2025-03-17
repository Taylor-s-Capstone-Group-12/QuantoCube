import 'package:flutter/material.dart';

class ProjectChat extends StatelessWidget {
  final String projectId;

  const ProjectChat({Key? key, required this.projectId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jackson Hon"), // Replace with actual user name
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          /// 🔹 Persistent Scam Warning
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[300],
            child: const Text(
              "Scam Alert! Do not make payment via QR codes or download external apps via links. Be alert with personal info.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),

          /// 🔹 Chat Messages (Dummy for now)
          Expanded(
            child: ListView(
              children: _buildMessageList(context),
            ),
          ),

          /// 🔹 Message Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// 🔹 Dummy Message Data
  List<Widget> _buildMessageList(BuildContext context) {
    List<Map<String, dynamic>> messages = [
      {"date": "20 June"},
      {
        "sender": "user1",
        "text": "Hey! Is the project ready?",
        "date": "20 June"
      },
      {
        "sender": "currentUser",
        "text": "Yes, I'll send updates soon.",
        "date": "20 June"
      },
      {"date": "21 June"},
      {"sender": "user1", "text": "Got it, thanks!", "date": "21 June"},
    ];

    String lastDate = ""; // Initialize with an empty string
    List<Widget> messageWidgets = [];

    for (var msg in messages) {
      if (msg.containsKey("date")) {
        lastDate = msg["date"] ?? ""; // Ensure lastDate is never null
        messageWidgets.add(_buildDateHeader(lastDate));
      } else {
        bool showDate = lastDate.isEmpty || lastDate != (msg["date"] ?? "");
        messageWidgets.add(_buildMessageBubble(context, msg, showDate));
      }
    }

    return messageWidgets;
  }

  /// 🔹 Date Header (20 June, 21 June, etc.)
  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }

  /// 🔹 Chat Bubble UI
  Widget _buildMessageBubble(
      BuildContext context, Map<String, dynamic> msg, bool showDate) {
    bool isCurrentUser =
        msg["sender"] == "currentUser"; // Replace with actual user check

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: showDate ? 4 : 2, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[800], // Primary color for user, gray for others
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["text"],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 🔹 Message Input Field
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              // TODO: Implement message send function
            },
          ),
        ],
      ),
    );
  }
}
