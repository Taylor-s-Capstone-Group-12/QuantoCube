import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/page/messaging/main/message_appbar.dart';
import 'package:quantocube/page/messaging/main/message_list.dart';
import 'package:quantocube/tests/sample_classes.dart';
import 'package:quantocube/tests/test_func.dart';
import 'package:quantocube/theme.dart';
import 'package:quantocube/utils/utils.dart';

final FirebaseFirestore _firestore =
    FirebaseFirestore.instance; // Initialize Firestore

class MessagePage extends StatefulWidget {
  const MessagePage({
    super.key,
    required this.projectId,
    this.isFirstTime = false,
  });

  final String projectId;
  final bool isFirstTime;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> ChatData = [];
  final FocusNode focusNode = FocusNode();

  late String userId;
  late bool isHomeowner;
  String otherUserName = 'Loading...';

  late TextEditingController _controller;
  late ScrollController _scrollController;

  Future<void> getRecepient() async {
    otherUserName = (await getOtherUserName(isHomeowner, widget.projectId))!;
    setState(() {}); // Update UI after fetching data
  }

  Future<void> initUser() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    isHomeowner = await getUserType(userId);

    await getRecepient(); // Wait for the recipient to load
    await loadMessages().then((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollToBottom();
      });
    }); // Wait for messages to load

    setState(() {}); // Refresh UI
  }

  @override
  void initState() {
    initUser();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 800), () {
          _scrollToBottom();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> loadMessages() async {
    try {
      QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .collection('chat')
          .orderBy('time', descending: false) // Sorting by time field
          .get();

      List<QueryDocumentSnapshot> chatDocs = chatSnapshot.docs;

      ChatData.clear();

      for (var chatDoc in chatDocs) {
        print('chatdoc: ${chatDoc.data()}');

        var data = chatDoc.data() as Map<String, dynamic>;

        print('time data type: ${data['time'].runtimeType}');

        // Convert Firestore Timestamp to DateTime, fallback to DateTime.now() if null
        final DateTime time =
            (data['time'] as Timestamp?)?.toDate() ?? DateTime.now();

        // Clone the map and add 'isPending'
        Map<String, dynamic> localData = {
          ...data, // Spread operator to copy existing key-value pairs
          'time': time, // Ensure time is converted
          'isPending': false, // Add your custom field
        };

        ChatData.add(localData);
      }

      // Sort messages safely
      //ChatData.sort((a, b) => a['time'].compareTo(b['time']));

      setState(() {}); // Update UI
    } catch (e) {
      kPrint("Error loading messages: $e");
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage(String message) {
    try {
      DateTime localTime = DateTime.now(); // Local timestamp

      setState(() {
        ChatData.add({
          'sender': userId,
          'type': 'message',
          'message': message,
          'time': localTime, // Local timestamp to display immediately
          'isPending': true, // Mark as pending to visually indicate it's unsent
        });
      });

      // Scroll to the bottom after adding the message
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });

      // Send to Firestore with server timestamp
      _firestore
          .collection('projects')
          .doc(widget.projectId)
          .collection('chat')
          .add({
        'sender': userId,
        'type': 'message',
        'message': message,
        'time': FieldValue.serverTimestamp(), // Will be set later by Firestore
      }).then((docRef) {
        // Once Firestore assigns a timestamp, update our local message
        docRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            Map<String, dynamic> newData =
                docSnapshot.data() as Map<String, dynamic>;
            if (newData['time'] is Timestamp) {
              DateTime serverTime = (newData['time'] as Timestamp).toDate();

              setState(() {
                // Replace the pending message with the Firestore-stored message
                int index = ChatData.indexWhere((msg) =>
                    msg['message'] == message && msg['isPending'] == true);
                if (index != -1) {
                  ChatData[index] = {
                    ...ChatData[index],
                    'time': serverTime,
                    'isPending': false, // No longer pending
                  };
                }
              });
            }
          }
        });
      });

      // Clear the input field
      _controller.clear();
    } catch (e) {
      kPrint("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessageAppBar(recepientName: otherUserName),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => focusNode.unfocus(),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('projects')
                    .doc(widget.projectId)
                    .collection('chat')
                    .orderBy('time', descending: false)
                    .snapshots(), // 🔥 Real-time updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  List<Map<String, dynamic>> chatList =
                      snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;

                    return {
                      ...data,
                      'time': (data['time'] as Timestamp?)?.toDate() ??
                          DateTime.now(),
                    };
                  }).toList();

                  // Scroll to bottom when messages update
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return MessageList(
                    userId: userId,
                    chatList: chatList,
                    controller: _scrollController,
                  );
                },
              ),
            ),
          ),
          MessageInput(
            controller: _controller,
            focusNode: focusNode,
            onTap: (String message) {
              sendMessage(message);
            },
          ),
        ],
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  const MessageInput(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.focusNode});

  final TextEditingController controller;
  final void Function(String) onTap;
  final FocusNode focusNode;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.focusNode.hasFocus ? 70 : 80,
        minWidth: MediaQuery.of(context).size.width,
      ),
      color: Theme.of(context).colorScheme.secondary,
      padding:
          EdgeInsets.only(top: 10, bottom: widget.focusNode.hasFocus ? 10 : 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 290,
            child: TextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: ProjectTheme.inputDecoration(context).copyWith(
                hintText: 'Aa',
                contentPadding: const EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFF333233),
                suffixIcon: IconButton(
                  style: IconButton.styleFrom(
                    overlayColor: Colors.white,
                    //highlightColor: Colors.white,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.insert_emoticon_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          SizedBox(
            height: 40,
            width: 35,
            child: Material(
              shape: const CircleBorder(),
              color: Theme.of(context).colorScheme.primary,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (widget.controller.text.isNotEmpty) {
                    widget.onTap(widget.controller.text);
                    widget.controller.clear();
                  }
                },
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
