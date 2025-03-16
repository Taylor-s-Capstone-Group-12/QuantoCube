import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/others/review_data.dart';

final ContractorProfileData dummyContractorProfile = ContractorProfileData(
    name: 'Jackson Hon',
    email: 'example@email.com',
    rating: 4.5,
    location: 'Petaling Jaya',
    about:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tempus non lectus ut ultricies. Quisque facilisis dolor sit amet justo elementum fermentum. Quisque non rutrum urna. Donec condimentum ac ligula sit amet rutrum. Nullam mi neque, bibendum in varius sed, porttitor at diam. Suspendisse at ultricies erat, sit amet egestas.',
    phoneNumber: '0123456789',
    completedProject: 10,
    completionRate: 0.9,
    appriciation: 5,
    profileImage:
        'https://img.freepik.com/free-photo/building-sector-industrial-workers-concept-confident-young-asian-engineer-construction-manager-reflective-clothes-helmet-cross-arms-smiling-sassy-ensuring-quality-white-wall_1258-17542.jpg');

List<ContractorReview> dummyReviews = [
  ContractorReview(
    name: "Alice",
    profileImg: null,
    review: "Great work! Highly recommended.",
    date: "2025-03-12",
    rating: "5.0",
  ),
  ContractorReview(
    name: "Bob",
    profileImg: null,
    review: "Very professional and on time.",
    date: "2025-03-10",
    rating: "4.8",
  ),
];
