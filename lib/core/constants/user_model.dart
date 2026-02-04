import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String? role;
  final String? phone;
  final String? token;
  final bool createFeedback;
  final String? profileImg;
  final String? gender;
  final String? birthday;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    this.role,
    this.phone,
    this.token,
    required this.createFeedback,
    this.profileImg,
    this.gender,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    String? birthday;
    if (data['birthday'] != null && data['birthday'].toString().isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(data['birthday'].toString());
        birthday = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (_) {
        birthday = null;
      }
    }

    return UserModel(
      id: data['_id'] ?? '',
      firstname: data['firstName'] ?? '',
      lastname: data['lastName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'],
      phone: data['phone'],
      token: json['token'] ?? data['token'],
      createFeedback: data['createReport'] ?? false,
      profileImg: data['profileImg'],
      gender: data['gender'],
      birthday: birthday,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        '_id': id,
        'firstName': firstname,
        'lastName': lastname,
        'email': email,
        'role': role,
        'phone': phone,
        'createReport': createFeedback,
        'profileImg': profileImg,
        'gender': gender,
        'birthday': birthday,
      },
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? role,
    String? phone,
    String? token,
    bool? createFeedback,
    String? profileImg,
    String? gender,
    String? birthday,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      createFeedback: createFeedback ?? this.createFeedback,
      profileImg: profileImg ?? this.profileImg,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
    );
  }
}
