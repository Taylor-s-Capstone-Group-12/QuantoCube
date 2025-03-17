class ChatPreview {
  final String name;
  final String projectName;
  final String? profileUrl;
  final String message;
  final DateTime time;
  final bool isNew;
  final bool isOnline;

  ChatPreview({
    this.profileUrl,
    required this.isNew,
    required this.projectName,
    required this.name,
    required this.message,
    required this.time,
    required this.isOnline,
  });

  // Create a ChatPreview object from a JSON object
  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      profileUrl: json['profileUrl'],
      projectName: json['projectName'],
      isNew: json['isNew'],
      name: json['name'],
      message: json['message'],
      time: DateTime.parse(json['time']),
      isOnline: json['isOnline'],
    );
  }

  // Create a JSON object from a ChatPreview object
  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'profileUrl': profileUrl,
      'isNew': isNew,
      'name': name,
      'message': message,
      'time': time.toIso8601String(),
      'isOnline': isOnline,
    };
  }
}
