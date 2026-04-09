class ReviewModel {
  final String userName;
  final double rating;
  final String comment;
  final String? date;
  final String? avatarUrl;

  ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
    this.date,
    this.avatarUrl,
  });
}
