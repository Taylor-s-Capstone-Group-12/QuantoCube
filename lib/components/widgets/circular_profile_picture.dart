import 'package:flutter/material.dart';

class CircularProfilePicture extends StatefulWidget {
  final String imageUrl; // Profile picture URL

  const CircularProfilePicture({
    super.key,
    required this.imageUrl,
  });

  @override
  State<CircularProfilePicture> createState() => _CircularProfilePictureState();
}

class _CircularProfilePictureState extends State<CircularProfilePicture> {
  bool imgError = false;

  void onError() {
    setState(() {
      imgError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(widget.imageUrl),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onBackgroundImageError: (object, stackTrace) => onError(),
      child: imgError
          ? const Icon(
              Icons.person,
              color: Colors.white,
            )
          : null,
    );
  }
}
