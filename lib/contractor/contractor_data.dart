class ContractorData {
  String name;
  String email;
  String phoneNumber;

  ContractorData({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory ContractorData.fromMap(Map<String, String> map) {
    return ContractorData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
