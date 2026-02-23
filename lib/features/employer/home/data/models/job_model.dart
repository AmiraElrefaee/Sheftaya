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
  final int? offersCount;

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
    this.imageUrl,
    this.offersCount,
  });

  String get experienceText => withoutExperience ? 'بدون خبرة' : 'خبرة مطلوبة';

  String get hoursText => '$shiftHours ساعات';

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
      'offersCount': offersCount,
    };
  }
}