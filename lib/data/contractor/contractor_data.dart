class ContractorProfileData {
  String name;
  String email;
  String phoneNumber;
  double rating;
  String location;
  String about;
  int completedProject;
  double completionRate;
  int appriciation;
  String? profileImage;

  ContractorProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.rating,
    required this.location,
    required this.about,
    required this.completedProject,
    required this.completionRate,
    required this.appriciation,
    this.profileImage,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'rating': rating.toString(),
      'location': location,
      'about': about,
      'completedProject': completedProject.toString(),
      'completionRate': completionRate.toString(),
      'appriciation': appriciation.toString(),
      'profileImage': profileImage ?? '',
    };
  }

  factory ContractorProfileData.fromMap(Map<String, String> map) {
    return ContractorProfileData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      rating: double.parse(map['rating'] ?? '0'),
      location: map['location'] ?? '',
      about: map['about'] ?? '',
      completedProject: int.parse(map['completedProject'] ?? '0'),
      completionRate: double.parse(map['completionRate'] ?? '0'),
      appriciation: int.parse(map['appriciation'] ?? '0'),
      profileImage: map['profileImage'],
    );
  }
}
