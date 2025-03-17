class ServiceRequestData {
  final String userID;
  final String contractorID;
  String service;
  String details;
  String location;
  DateTime startDate;
  DateTime endDate;
  int budget;
  String? additionalComment;

  ServiceRequestData({
    required this.userID,
    required this.contractorID,
    required this.service,
    required this.details,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.budget,
    this.additionalComment,
  });

  // Create a ServiceRequestData object from a JSON object
  factory ServiceRequestData.fromJson(Map<String, dynamic> json) {
    return ServiceRequestData(
      userID: json['userID'],
      contractorID: json['contractorID'],
      service: json['service'],
      details: json['details'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      budget: json['budget'],
      additionalComment: json['additionalComment'],
    );
  }

  // Create a JSON object from a ServiceRequestData object
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'contractorID': contractorID,
      'service': service,
      'details': details,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'additionalComment': additionalComment,
    };
  }
}
