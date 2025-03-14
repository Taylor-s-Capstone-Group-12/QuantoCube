import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantocube/components/components.dart';
import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';
import 'package:quantocube/tests/sample_classes.dart';

class ContractorProfile extends StatelessWidget {
  final ContractorProfileData contractor;
  final List<ContractorReview> reviews;

  const ContractorProfile({
    super.key,
    required this.contractor,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            // Profile Name
            Text(
              contractor.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            /// Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: contractor.profileImage != null
                        ? NetworkImage(contractor.profileImage!)
                        : null,
                    backgroundColor: Colors.grey[800],
                    child: contractor.profileImage == null
                        ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(contractor.name, style: _headerTextStyle()),
                  Text("📍 ${contractor.location}", style: _infoTextStyle()),
                  Text("📧 ${contractor.email}", style: _infoTextStyle()),
                  Text("📞 ${contractor.phoneNumber}", style: _infoTextStyle()),
                  const SizedBox(height: 10),
                  Text("⭐ ${contractor.rating} / 5.0",
                      style: _highlightTextStyle()),
                  Text("✅ Completed: ${contractor.completedProject} projects",
                      style: _infoTextStyle()),
                  Text("📊 Completion Rate: ${contractor.completionRate}%",
                      style: _infoTextStyle()),
                  Text("🏆 Appreciation: ${contractor.appriciation}",
                      style: _infoTextStyle()),
                  const SizedBox(height: 10),
                  Text(contractor.about, style: _infoTextStyle()),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Reviews Section
            Text("Reviews", style: _headerTextStyle()),
            const SizedBox(height: 10),
            Column(
              children:
                  reviews.map((review) => _buildReviewCard(review)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Review Card UI
  Widget _buildReviewCard(ContractorReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: review.profileImg != null
                    ? NetworkImage(review.profileImg!)
                    : null,
                backgroundColor: Colors.grey[800],
                child: review.profileImg == null
                    ? const Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review.name, style: _highlightTextStyle()),
                  Text(review.date, style: _infoTextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("⭐ ${review.rating}/5.0",
              style: _highlightTextStyle(fontSize: 14)),
          const SizedBox(height: 5),
          Text(review.review, style: _infoTextStyle()),
        ],
      ),
    );
  }

  /// Box Decoration for Outlined Containers
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(12),
    );
  }

  /// Text Styles
  TextStyle _headerTextStyle() => const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _infoTextStyle({double fontSize = 14}) =>
      TextStyle(fontSize: fontSize, color: Colors.white70);
  TextStyle _highlightTextStyle({double fontSize = 16}) => TextStyle(
      fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white);
}

// Codes for the proper designs.

// class ContractorProfile extends StatelessWidget {
//   ContractorProfile({
//     super.key,
//   });

//   final ContractorProfileData contractorProfile = sampleContractorProfile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.secondary,
//       body: Stack(
//         children: [ProfileHeader(contractorProfile: contractorProfile)],
//       ),
//     );
//   }
// }

// class ProfileHeader extends StatelessWidget {
//   const ProfileHeader({super.key, required this.contractorProfile});

//   final ContractorProfileData contractorProfile;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const CircularBackButton(),
//             CircularProfilePicture(
//                 imageUrl: contractorProfile.profileImage ?? ''),
//           ],
//         ),
//       ],
//     );
//   }
// }
