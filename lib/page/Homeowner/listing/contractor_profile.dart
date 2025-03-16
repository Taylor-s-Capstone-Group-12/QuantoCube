import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';
import 'package:quantocube/tests/sample_classes.dart';

// Codes for the proper designs.

class ContractorProfile extends StatelessWidget {
  const ContractorProfile({
    super.key,
    required this.contractor,
    required this.reviews,
  });

  final ContractorProfileData contractor;
  final List<ContractorReview> reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [ProfileHeader(contractor: contractor)],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.contractor});

  final ContractorProfileData contractor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircularBackButton(),
            CircularProfilePicture(imageUrl: contractor.profileImage ?? ''),
          ],
        ),
      ],
    );
  }
}
