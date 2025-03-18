import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';

class MessageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessageAppBar({
    super.key,
    required this.contractor,
  });

  final Map<String, String> contractor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 10),
        child: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.primary,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: colorScheme.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
        ),
      ),
      toolbarHeight: 85,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProfilePicture(
              imageUrl: contractor['profilePic'],
              radius: 25,
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contractor['name'] ?? 'ERROR: Name not found',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  contractor['status'] ?? 'Offline',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB8B8B8),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      //actionsIconTheme: IconThemeData(color: colorScheme.primary, size: 40),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(85);
}
