import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/page/messaging/main/message_appbar.dart';
import 'package:quantocube/page/messaging/main/message_list.dart';
import 'package:quantocube/theme.dart';

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
  Map<String, String> contractor = {
    'name': '',
    'profilePic': '',
    'status': '',
  };

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    getContractor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getContractor() {
    //TODO: Implement getting contractor from firebase firestore

    // temp data
    contractor = {
      'name': 'John Doe',
      'status': 'Online',
      'profilePic':
          'https://img.freepik.com/free-photo/building-sector-industrial-workers-concept-confident-young-asian-engineer-construction-manager-reflective-clothes-helmet-cross-arms-smiling-sassy-ensuring-quality-white-wall_1258-17542.jpg',
    };
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: MessageAppBar(contractor: contractor),
      body: Column(
        children: [
          const Expanded(
            child: MessageList(
              chatList: [],
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
