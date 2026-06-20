class JobModel {
  final String title;
  final String place;
  final double longitude;
  final double latitude;
  final String mainPlace;
  final String address;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int dailyWorkHours;
  final int requiredWorkers;
  final int pricePerHour;
  final String experienceLevel;
  final String details;
  final String paymentMethod;

  JobModel({
    required this.title,
    required this.place,
    required this.longitude,
    required this.latitude,
    required this.mainPlace,
    required this.address,
    required this.startDateTime,
    required this.endDateTime,
    required this.dailyWorkHours,
    required this.requiredWorkers,
    required this.pricePerHour,
    required this.experienceLevel,
    required this.details,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "place": place,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
        "mainPlace": mainPlace,
        "address": address
      },
      "startDateTime": startDateTime.toIso8601String(),
      "endDateTime": endDateTime.toIso8601String(),
      "dailyWorkHours": dailyWorkHours, // ✅ للنشر الجديد بس
      "requiredWorkers": requiredWorkers,
      "pricePerHour": {
        "amount": pricePerHour,
        "currency": "EGP"
      },
      "experienceLevel": experienceLevel,
      "details": details,
      "paymentMethod": paymentMethod
    };
  }
}