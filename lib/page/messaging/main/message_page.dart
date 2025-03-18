import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/page/messaging/main/message_appbar.dart';
import 'package:quantocube/page/messaging/main/message_list.dart';
import 'package:quantocube/tests/sample_classes.dart';
import 'package:quantocube/theme.dart';
import 'package:quantocube/utils/get_user_type.dart';

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

Future<String?> getOtherUserName(bool isHomeowner, String projectId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get project document
    DocumentSnapshot projectDoc =
        await firestore.collection('projects').doc(projectId).get();

    if (!projectDoc.exists)
      return null; // If project doesn't exist, return null

    // Get the corresponding user ID (homeowner or contractor)
    String userId = isHomeowner
        ? projectDoc['contractorId'] as String? ?? ''
        : projectDoc['homeownerId'] as String? ?? '';

    if (userId.isEmpty) return null; // Return null if no user ID found

    // Get user document by retrieved userId
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    if (!userDoc.exists) return null;

    return userDoc['name'] as String? ??
        'Unknown'; // Return the name or 'Unknown'
  } catch (e) {
    print("Error fetching other user name: $e");
    return null; // Return null in case of error
  }
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> ChatData = [];

  late String userId;
  late bool isHomeowner;
  late String otherUserName;

  late TextEditingController _controller;

  void getRecepient() async {
    otherUserName = "Error";
    otherUserName = getOtherUserName(isHomeowner, widget.projectId) as String;
  }

  void initUser() async {
    userId = FirebaseAuth.instance.currentUser!.uid;
    isHomeowner = await getUserType(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void initState() {
    initUser();
    getRecepient();
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: MessageAppBar(
        recepientName: otherUserName,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              chatList: sampleChatData,
            ),
          ),
          MessageInput(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  const MessageInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _focusNode.hasFocus ? 70 : 80,
        minWidth: MediaQuery.of(context).size.width,
      ),
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.only(top: 10, bottom: _focusNode.hasFocus ? 10 : 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 290,
            child: TextField(
              onTapOutside: (event) => _focusNode.unfocus(),
              focusNode: _focusNode,
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
                onTap: () {},
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
