import 'package:json_annotation/json_annotation.dart';

part 'update_profile_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateProfileRequestBody {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final UpdateTeacherProfileBody? teacherProfile;
  final UpdateStudentProfileBody? studentProfile;

  UpdateProfileRequestBody({
    this.firstName,
    this.lastName,
    this.phone,
    this.teacherProfile,
    this.studentProfile,
  });

  factory UpdateProfileRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileRequestBodyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateTeacherProfileBody {
  @JsonKey(name: 'school')
  final String? school;

  @JsonKey(name: 'pricePerHour')
  final num? pricePerHour;

  final String? bio;

  @JsonKey(name: 'experienceYears')
  final int? experienceYears;

  @JsonKey(name: 'education_system')
  final List<String>? educationSystem;

  @JsonKey(name: 'academic_stages')
  final List<String>? academicStages;

  final List<String>? subjects;

  UpdateTeacherProfileBody({
    this.school,
    this.pricePerHour,
    this.bio,
    this.experienceYears,
    this.educationSystem,
    this.academicStages,
    this.subjects,
  });

  factory UpdateTeacherProfileBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateTeacherProfileBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTeacherProfileBodyToJson(this);
}

@JsonSerializable()
class UpdateStudentProfileBody {
  final String? grade;

  @JsonKey(name: 'education_system')
  final String? educationSystem;

  final String? school;

  UpdateStudentProfileBody({
    this.grade,
    this.educationSystem,
    this.school,
  });

  factory UpdateStudentProfileBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateStudentProfileBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateStudentProfileBodyToJson(this);
}