class UpdateProfileRequestBody {
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? city;
  final String? birthday;
  final UpdateWorkerProfileBody? workerProfile;
  final UpdateEmployerProfileBody? employerProfile;

  const UpdateProfileRequestBody({
    this.firstName,
    this.lastName,
    this.phone,
    this.city,
    this.birthday,
    this.workerProfile,
    this.employerProfile,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map['firstName'] = firstName;
    if (lastName != null) map['lastName'] = lastName;
    if (phone != null) map['phone'] = phone;
    if (city != null) map['city'] = city;
    if (birthday != null) map['birthday'] = birthday;
    if (workerProfile != null) map['workerProfile'] = workerProfile!.toJson();
    if (employerProfile != null) {
      map['employerProfile'] = employerProfile!.toJson();
    }
    return map;
  }
}

class UpdateWorkerProfileBody {
  final String? education;
  final String? professionalStatus;
  final List<String>? pastExperience;
  final List<String>? jobsLookedFor;
  final int? experienceYears;
  final double? expectedHourlyRate;

  const UpdateWorkerProfileBody({
    this.education,
    this.professionalStatus,
    this.pastExperience,
    this.jobsLookedFor,
    this.experienceYears,
    this.expectedHourlyRate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (education != null) map['education'] = education;
    if (professionalStatus != null) {
      map['professionalStatus'] = professionalStatus;
    }
    if (pastExperience != null) map['pastExperience'] = pastExperience;
    if (jobsLookedFor != null) map['jobsLookedFor'] = jobsLookedFor;
    if (experienceYears != null) map['experienceYears'] = experienceYears;
    if (expectedHourlyRate != null) {
      map['expectedHourlyRate'] = {
        'amount': expectedHourlyRate,
        'currency': 'EGP',
      };
    }
    return map;
  }
}

class UpdateEmployerProfileBody {
  final String? companyName;
  final String? companyType;
  final String? companyAddress;
  final String? city;
  final String? taxNumber;

  const UpdateEmployerProfileBody({
    this.companyName,
    this.companyType,
    this.companyAddress,
    this.city,
    this.taxNumber,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (companyName != null) map['companyName'] = companyName;
    if (companyType != null) map['companyType'] = companyType;
    if (companyAddress != null) map['companyAddress'] = companyAddress;
    if (city != null) map['city'] = city;
    if (taxNumber != null) map['taxNumber'] = taxNumber;
    return map;
  }
}
