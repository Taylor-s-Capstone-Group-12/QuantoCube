import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/data/messaging/chat_preview_data.dart';
import 'package:quantocube/tests/sample_classes.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<ChatPreview> _chatList = [];

  @override
  void initState() {
    getChatList();
    super.initState();
  }

  void getChatList() {
    //TODO: Implement getting chat lists from firebase firestore

    // temp data
    _chatList = sampleChatPreviews;

    // sort the chats based on recent time
    _chatList.sort((a, b) => b.time.compareTo(a.time));
  }

  void onSearch(String query) {
    // TODO: Implement search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatListAppBar(
        onSearch: onSearch,
      ),
      body: ChatList(
        chatList: _chatList,
      ),
    );
  }
}

class ChatListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatListAppBar({
    super.key,
    required this.onSearch,
  });

  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppBarWithSearchSwitch(
      onChanged: onSearch,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: colorScheme.primary, size: 30),
      backgroundColor: colorScheme.secondary,
      searchInputDecoration: InputDecoration(
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderSide: BorderSide.none, // No outline when not focused
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .primary, // Primary color outline when focused
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      appBarBuilder: (context) => AppBar(
        backgroundColor: colorScheme.secondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
          ),
        ),
        toolbarHeight: 75,
        title: const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Message',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        actionsIconTheme: IconThemeData(color: colorScheme.primary, size: 40),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: AppBarSearchButton(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.chatList});

  final List<ChatPreview> chatList;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 21),
      child: ListView.builder(
        itemCount: widget.chatList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ChatListItem(chatPreview: widget.chatList[index]),
              if (index != widget.chatList.length - 1)
                const Divider(
                  color: Color(0xFF1D1D1D),
                  height: 0,
                  thickness: 1,
                ),
            ],
          );
        },
      ),
    );
  }
}

class ChatListItem extends StatefulWidget {
  const ChatListItem({super.key, required this.chatPreview});

  final ChatPreview chatPreview;

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircularProfilePicture(
                imageUrl: widget.chatPreview.profileUrl,
                radius: 25,
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: widget.chatPreview.isOnline
                        ? Colors.green
                        : Colors.grey, // Online indicator
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12), // Space between avatar & text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.chatPreview.projectName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.chatPreview.name,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.chatPreview.message,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatChatTime(widget.chatPreview.time),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              if (widget.chatPreview.isNew)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Unread message indicator
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
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
}
