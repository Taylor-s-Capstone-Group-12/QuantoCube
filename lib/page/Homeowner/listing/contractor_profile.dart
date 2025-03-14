import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/tests/sample_classes.dart';

class ContractorProfile extends StatelessWidget {
  ContractorProfile({
    super.key,
  });

  final ContractorProfileData contractorProfile = sampleContractorProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [ProfileHeader(contractorProfile: contractorProfile)],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.contractorProfile});

  final ContractorProfileData contractorProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircularBackButton(),
            CircularProfilePicture(
                imageUrl: contractorProfile.profileImage ?? ''),
          ],
        ),
      ],
    );
  }
}
