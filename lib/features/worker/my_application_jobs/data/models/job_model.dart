enum ApplicationStatus {
  pending,
  accepted,
  rejected,
  completed,
  reportUnderReview,
  reportResolved,
  unknown,
}

class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String postedAt;
  final String? imageUrl;

  final ApplicationStatus applicationStatus;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.postedAt,
    this.imageUrl,
    required this.applicationStatus,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final job = json['job'];

    return JobModel(
      id: job['_id'] ?? '',
      title: job['title'] ?? '',
      company: job['companyDetails']?['companyName'] ?? '',
      location: job['place'] ?? '',
      postedAt: json['postedAt'] ?? '',
      imageUrl: job['JobImages'] != null && (job['JobImages'] as List).isNotEmpty
          ? job['JobImages'][0]
          : null,

      applicationStatus: _mapStatus(json['applicationStatus']),
    );
  }

  static ApplicationStatus _mapStatus(String? status) {
    switch (status) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'accepted':
        return ApplicationStatus.accepted;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'completed':
        return ApplicationStatus.completed;
      case 'reportUnderReview':
        return ApplicationStatus.reportUnderReview;
      case 'reportResolved':
        return ApplicationStatus.reportResolved;
      default:
        return ApplicationStatus.unknown;
    }
  }
}