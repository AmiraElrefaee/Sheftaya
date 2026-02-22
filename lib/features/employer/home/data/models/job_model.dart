enum JobStatus {
  active,
  completed,
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
  final int offersCount;

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
    required this.offersCount,
  });

  String get experienceText => withoutExperience ? 'بدون خبرة' : 'خبرة مطلوبة';

  String get hoursText => '$shiftHours ساعات';
}
