import 'package:flutter/material.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';

class ProfileDraggable extends StatefulWidget {
  const ProfileDraggable({
    super.key,
    required this.contractor,
    required this.reviews,
  });

  final ContractorProfileData contractor;
  final List<ContractorReview> reviews;

  @override
  State<ProfileDraggable> createState() => _ProfileDraggableState();
}

class _ProfileDraggableState extends State<ProfileDraggable> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController) {
      return ColoredBox(
        color: colorScheme.surface,
        child: Text('Text'),
      );
    });
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
