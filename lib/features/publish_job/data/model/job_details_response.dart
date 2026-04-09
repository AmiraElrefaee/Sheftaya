class EmployerJobDetailsResponse {
  final String status;
  final JobDetailsData data;

  EmployerJobDetailsResponse({
    required this.status,
    required this.data,
  });

  factory EmployerJobDetailsResponse.fromJson(Map<String, dynamic> json) {
    return EmployerJobDetailsResponse(
      status: json['status'],
      data: JobDetailsData.fromJson(json['data']),
    );
  }
}

class JobDetailsData {
  final JobDetails job;

  JobDetailsData({required this.job});

  factory JobDetailsData.fromJson(Map<String, dynamic> json) {
    return JobDetailsData(
      job: JobDetails.fromJson(json['job']),
    );
  }
}

class JobDetails {
  final String id;
  final String title;
  final String mainPlace; // من جوا الـ location
  final String address;   // من جوا الـ location
  final int dailyWorkHours;
  final int requiredWorkers;
  final String experienceLevel;
  final String details;
  final int price; // amount
  final String startDateTime;

  JobDetails({
    required this.id,
    required this.title,
    required this.mainPlace,
    required this.address,
    required this.dailyWorkHours,
    required this.requiredWorkers,
    required this.experienceLevel,
    required this.details,
    required this.price,
    required this.startDateTime,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      id: json['_id'],
      title: json['title'],
      mainPlace: json['location']['mainPlace'], // الوصول للـ mainPlace
      address: json['location']['address'],     // الوصول للـ address
      dailyWorkHours: json['dailyWorkHours'],
      requiredWorkers: json['requiredWorkers'],
      experienceLevel: json['experienceLevel'],
      details: json['details'],
      price: json['pricePerHour']['amount'],    // الوصول للسعر
      startDateTime: json['startDateTime'],     // التاريخ
    );
  }
}