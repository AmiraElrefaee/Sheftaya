import 'package:sheftaya/features/worker/home/data/models/review_model.dart';

enum JobStatus {
  active,
  completed,
  rejected,
  accepted,
  reportResolved,
  reportUnderReview,
}

class JobModel {
  final String id;
  final String title;
  final String company;
  final String? imageUrl;
  final String location;
  final double salary;
  final String postedAt;
  final JobStatus status;
  final int applicantsCount;

  final String shiftTime;
  final String shiftDate;
  final bool withoutExperience;
  final int shiftHours;
  final String? requirements;
  final String? details;
  final List<ReviewModel>? reviews;
  final int? offersCount;
  final String? ownerName;
  final int? reviewsCount;
  final double? rating;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.postedAt,
    required this.status,
    this.applicantsCount = 0,
    this.shiftTime = '9 صباحا',
    this.shiftDate = '3 ديسمبر',
    this.withoutExperience = true,
    this.shiftHours = 4,
    this.requirements,
    this.details,
    this.reviews,
    this.imageUrl,
    this.offersCount,
    this.ownerName,
    this.reviewsCount,
    this.rating,
  });

  String get experienceText => withoutExperience ? 'بدون خبرة' : 'خبرة مطلوبة';

  String get hoursText => '$shiftHours ساعات';

  String get experienceLevel => withoutExperience ? 'بدون خبرة' : 'خبرة مطلوبة';

  String get shiftEndTime {
    // Simple calculation: add hours to start time
    final parts = shiftTime.split(' ');
    if (parts.length == 2) {
      final timePart = parts[0];
      final period = parts[1];
      final timeComponents = timePart.split(':');
      if (timeComponents.length == 2) {
        final hour = int.tryParse(timeComponents[0]) ?? 9;
        final minute = int.tryParse(timeComponents[1]) ?? 0;
        final endHour = (hour + shiftHours) % 12;
        final endHourStr = endHour == 0 ? '12' : endHour.toString();
        return '$endHourStr:${minute.toString().padLeft(2, '0')} $period';
      }
    }
    return '6:00 م'; // fallback
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: (json['salary'] as num).toDouble(),
      postedAt: json['postedAt'],
      status: JobStatus.values[json['status']],
      applicantsCount: json['applicantsCount'] ?? 0,
      shiftTime: json['shiftTime'] ?? '9 صباحا',
      shiftDate: json['shiftDate'] ?? '3 ديسمبر',
      withoutExperience: json['withoutExperience'] ?? true,
      shiftHours: json['shiftHours'] ?? 4,
      imageUrl: json['imageUrl'],
      offersCount: json['offersCount'],
      details: json['details'],
      requirements: json['requirements'],
      reviews: null,
      ownerName: json['ownerName'],
      reviewsCount: json['reviewsCount'],
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'imageUrl': imageUrl,
      'location': location,
      'salary': salary,
      'postedAt': postedAt,
      'status': status.index,
      'applicantsCount': applicantsCount,
      'shiftTime': shiftTime,
      'shiftDate': shiftDate,
      'withoutExperience': withoutExperience,
      'shiftHours': shiftHours,
      'requirements': requirements,
      'details': details,
      'offersCount': offersCount,
      'ownerName': ownerName,
      'reviewsCount': reviewsCount,
      'rating': rating,
    };
  }
}
