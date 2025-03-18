import 'package:quantocube/data/contractor/contractor_data.dart';
import 'package:quantocube/data/messaging/chat_preview_data.dart';
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

List<ChatPreview> sampleChatPreviews = [
  ChatPreview(
    name: "Alice Johnson",
    projectName: 'Bathroom Renovation',
    profileUrl: null,
    message: "Hey! Are we still on for tomorrow?",
    time: DateTime.now().subtract(const Duration(minutes: 5)),
    isNew: true,
    isOnline: true,
  ),
  ChatPreview(
    projectName: 'Kitchen Renovation',
    name: "Bob Smith",
    profileUrl: "https://example.com/bob.jpg",
    message: "Just sent the files you asked for.",
    time: DateTime.now().subtract(const Duration(hours: 1)),
    isNew: false,
    isOnline: true,
  ),
  ChatPreview(
    projectName: 'Living Room Renovation',
    name: "Charlie Doe",
    profileUrl: null,
    message: "LOL, that was hilarious!",
    time: DateTime.now().subtract(const Duration(days: 1)),
    isNew: true,
    isOnline: false,
  ),
  ChatPreview(
    projectName: 'Bedroom Renovation',
    name: "Diana Prince",
    profileUrl: "https://example.com/diana.jpg",
    message: "Good night! Talk to you later.",
    time: DateTime.now().subtract(const Duration(hours: 10)),
    isNew: false,
    isOnline: true,
  ),
  ChatPreview(
    projectName: 'Garden Renovation',
    name: "Ethan Hunt",
    profileUrl: "https://example.com/ethan.jpg",
    message: "Mission accomplished. 😎",
    time: DateTime.now().subtract(const Duration(minutes: 30)),
    isNew: true,
    isOnline: false,
  ),
];

List<Map<String, dynamic>> sampleChatData = [
  // March 15, 2025
  {
    'type': 'message',
    'message': 'Hey, how are you?',
    'isSender': 'true',
    'date': DateTime(2025, 3, 15, 9, 15), // March 15, 9:15 AM
  },
  {
    'type': 'message',
    'message': 'I’m good, thanks! You?',
    'isSender': 'false',
    'date': DateTime(2025, 3, 15, 9, 17), // March 15, 9:17 AM
  },
  {
    'type': 'message',
    'message': 'Just working on my Flutter project.',
    'isSender': 'true',
    'date': DateTime(2025, 3, 15, 10, 00), // March 15, 10:00 AM
  },

  // March 16, 2025
  {
    'type': 'message',
    'message': 'Nice! Have you tried Firebase for real-time updates?',
    'isSender': 'false',
    'date': DateTime(2025, 3, 16, 14, 30), // March 16, 2:30 PM
  },
  {
    'type': 'attachment',
    'message': 'Sent a file: project_notes.pdf',
    'isSender': 'true',
    'onTap': () {}, // Simulated file tap action
    'date': DateTime(2025, 3, 16, 14, 35), // March 16, 2:35 PM
  },

  // March 17, 2025
  {
    'type': 'message',
    'message': 'Hey, are you free for a call later?',
    'isSender': 'false',
    'date': DateTime(2025, 3, 17, 18, 00), // March 17, 6:00 PM
  },
  {
    'type': 'message',
    'message': 'Yeah, let’s do it at 8 PM.',
    'isSender': 'true',
    'date': DateTime(2025, 3, 17, 18, 10), // March 17, 6:10 PM
  },
];
