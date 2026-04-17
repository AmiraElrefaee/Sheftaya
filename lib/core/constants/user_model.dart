import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? role;
  final String? phone;
  final String? token;
  final String? profileImg;
  final String? birthday;
  final String? city;

  // Worker profile
  final String? education;
  final String? professionalStatus;
  final List<String>? pastExperience;
  final List<String>? jobsLookedFor;
  final int? experienceYears;
  final double? expectedHourlyRate;
  final String? healthCertificate;

  // Employer profile
  final String? companyName;
  final String? companyType;
  final String? companyAddress;
  final String? companyCity;
  final List<String>? companyImages;

  const UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.role,
    this.phone,
    this.token,
    this.profileImg,
    this.birthday,
    this.city,
    this.education,
    this.professionalStatus,
    this.pastExperience,
    this.jobsLookedFor,
    this.experienceYears,
    this.expectedHourlyRate,
    this.healthCertificate,
    this.companyName,
    this.companyType,
    this.companyAddress,
    this.companyCity,
    this.companyImages,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    String? birthday;
    if (data['birthday'] != null && data['birthday'].toString().isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(data['birthday'].toString());
        birthday = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (_) {}
    }
    return UserModel(
      id: data['_id'] ?? '',
      firstname: data['firstName'] ?? '',
      lastname: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'],
      phone: data['phone'],
      token: json['token'] ?? data['token'],
      profileImg: data['profileImg'],
      birthday: birthday,
      city: data['city'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': {
          '_id': id,
          'firstName': firstname,
          'lastName': lastname,
          'email': email,
          'role': role,
          'phone': phone,
          'profileImg': profileImg,
          'birthday': birthday,
          'city': city,
        },
        'token': token,
      };

  UserModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? role,
    String? phone,
    String? token,
    String? profileImg,
    String? birthday,
    String? city,
    String? education,
    String? professionalStatus,
    List<String>? pastExperience,
    List<String>? jobsLookedFor,
    int? experienceYears,
    double? expectedHourlyRate,
    String? healthCertificate,
    String? companyName,
    String? companyType,
    String? companyAddress,
    String? companyCity,
    List<String>? companyImages,
  }) =>
      UserModel(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        role: role ?? this.role,
        phone: phone ?? this.phone,
        token: token ?? this.token,
        profileImg: profileImg ?? this.profileImg,
        birthday: birthday ?? this.birthday,
        city: city ?? this.city,
        education: education ?? this.education,
        professionalStatus: professionalStatus ?? this.professionalStatus,
        pastExperience: pastExperience ?? this.pastExperience,
        jobsLookedFor: jobsLookedFor ?? this.jobsLookedFor,
        experienceYears: experienceYears ?? this.experienceYears,
        expectedHourlyRate: expectedHourlyRate ?? this.expectedHourlyRate,
        healthCertificate: healthCertificate ?? this.healthCertificate,
        companyName: companyName ?? this.companyName,
        companyType: companyType ?? this.companyType,
        companyAddress: companyAddress ?? this.companyAddress,
        companyCity: companyCity ?? this.companyCity,
        companyImages: companyImages ?? this.companyImages,
      );
}