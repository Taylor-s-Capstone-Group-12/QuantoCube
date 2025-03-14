class ContractorReview {
  final String name;
  final String review;
  final String date;
  final String rating;
  final String? profileImg;

  ContractorReview({
    required this.name,
    required this.profileImg,
    required this.review,
    required this.date,
    required this.rating,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'profileImg': profileImg ?? '',
      'review': review,
      'date': date,
      'rating': rating,
    };
  }

  factory ContractorReview.fromMap(Map<String, String> map) {
    return ContractorReview(
      name: map['name'] ?? '',
      profileImg: map['profileImg'] ?? '',
      review: map['review'] ?? '',
      date: map['date'] ?? '',
      rating: map['rating'] ?? '',
    );
  }
}
