import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';
import 'package:quantocube/page/homeowner/listing/profile_draggable.dart';
import 'package:quantocube/page/homeowner/listing/profile_header.dart';

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
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: ProfileHeader(contractor: contractor)),
          Align(
              alignment: Alignment.bottomCenter,
              child:
                  ProfileDraggable(contractor: contractor, reviews: reviews)),
        ],
      ),
    );
  }
}
