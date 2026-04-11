// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileRequestBody _$UpdateProfileRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateProfileRequestBody(
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  teacherProfile: json['teacherProfile'] == null
      ? null
      : UpdateTeacherProfileBody.fromJson(
          json['teacherProfile'] as Map<String, dynamic>,
        ),
  studentProfile: json['studentProfile'] == null
      ? null
      : UpdateStudentProfileBody.fromJson(
          json['studentProfile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UpdateProfileRequestBodyToJson(
  UpdateProfileRequestBody instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'teacherProfile': instance.teacherProfile?.toJson(),
  'studentProfile': instance.studentProfile?.toJson(),
};

UpdateTeacherProfileBody _$UpdateTeacherProfileBodyFromJson(
  Map<String, dynamic> json,
) => UpdateTeacherProfileBody(
  school: json['school'] as String?,
  pricePerHour: json['pricePerHour'] as num?,
  bio: json['bio'] as String?,
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  educationSystem: (json['education_system'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  academicStages: (json['academic_stages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  subjects: (json['subjects'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$UpdateTeacherProfileBodyToJson(
  UpdateTeacherProfileBody instance,
) => <String, dynamic>{
  'school': instance.school,
  'pricePerHour': instance.pricePerHour,
  'bio': instance.bio,
  'experienceYears': instance.experienceYears,
  'education_system': instance.educationSystem,
  'academic_stages': instance.academicStages,
  'subjects': instance.subjects,
};

UpdateStudentProfileBody _$UpdateStudentProfileBodyFromJson(
  Map<String, dynamic> json,
) => UpdateStudentProfileBody(
  grade: json['grade'] as String?,
  educationSystem: json['education_system'] as String?,
  school: json['school'] as String?,
);

Map<String, dynamic> _$UpdateStudentProfileBodyToJson(
  UpdateStudentProfileBody instance,
) => <String, dynamic>{
  'grade': instance.grade,
  'education_system': instance.educationSystem,
  'school': instance.school,
};
