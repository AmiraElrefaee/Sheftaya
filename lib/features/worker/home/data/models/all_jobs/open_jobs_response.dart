import 'package:json_annotation/json_annotation.dart';
import 'package:sheftaya/features/employer/home/data/models/job_model.dart';

part 'open_jobs_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenJobsResponse {
  final String? status;
  final int? results;
  final List<OpenJobModel>? data;

  OpenJobsResponse({this.status, this.results, this.data});

  factory OpenJobsResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenJobsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OpenJobsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OpenJobModel {
  @JsonKey(name: '_id')
  final String id;

  final JobLocation? location;
  final PricePerHour? pricePerHour;
  final JobPayment? payment;
  final JobConfirmation? confirmation;
  final CancellationPolicy? cancellationPolicy;

  final String? employerId;
  final String? title;
  final String? place;
  final String? startDateTime;
  final String? endDateTime;
  final int? dailyWorkHours;
  final int? requiredWorkers;
  final int? acceptedWorkersCount;
  final String? experienceLevel;
  final String? details;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  OpenJobModel({
    required this.id,
    this.location,
    this.pricePerHour,
    this.payment,
    this.confirmation,
    this.cancellationPolicy,
    this.employerId,
    this.title,
    this.place,
    this.startDateTime,
    this.endDateTime,
    this.dailyWorkHours,
    this.requiredWorkers,
    this.acceptedWorkersCount,
    this.experienceLevel,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory OpenJobModel.fromJson(Map<String, dynamic> json) =>
      _$OpenJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$OpenJobModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class JobLocation {
  final String? type;
  final List<num>? coordinates;
  final String? mainPlace;
  final String? address;

  JobLocation({this.type, this.coordinates, this.mainPlace, this.address});

  factory JobLocation.fromJson(Map<String, dynamic> json) =>
      _$JobLocationFromJson(json);

  Map<String, dynamic> toJson() => _$JobLocationToJson(this);
}

@JsonSerializable()
class PricePerHour {
  final num? amount;
  final String? currency;

  PricePerHour({this.amount, this.currency});

  factory PricePerHour.fromJson(Map<String, dynamic> json) =>
      _$PricePerHourFromJson(json);

  Map<String, dynamic> toJson() => _$PricePerHourToJson(this);
}

@JsonSerializable()
class JobPayment {
  final String? method;
  final String? status;
  final num? totalAmount;
  final num? platformFee;

  JobPayment({this.method, this.status, this.totalAmount, this.platformFee});

  factory JobPayment.fromJson(Map<String, dynamic> json) =>
      _$JobPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$JobPaymentToJson(this);
}

@JsonSerializable()
class JobConfirmation {
  final bool? employerConfirmed;
  final int? workersConfirmedCount;

  JobConfirmation({this.employerConfirmed, this.workersConfirmedCount});

  factory JobConfirmation.fromJson(Map<String, dynamic> json) =>
      _$JobConfirmationFromJson(json);

  Map<String, dynamic> toJson() => _$JobConfirmationToJson(this);
}

@JsonSerializable()
class CancellationPolicy {
  final String? freeCancelUntil;
  final String? penaltyAfter;

  CancellationPolicy({this.freeCancelUntil, this.penaltyAfter});

  factory CancellationPolicy.fromJson(Map<String, dynamic> json) =>
      _$CancellationPolicyFromJson(json);

  Map<String, dynamic> toJson() => _$CancellationPolicyToJson(this);
}

extension OpenJobModelToJobModelMapping on OpenJobModel {
  JobModel toJobModel() {
    JobStatus parseStatus(String? status) {
      switch (status?.toLowerCase()) {
        case 'active':
          return JobStatus.active;
        case 'completed':
          return JobStatus.completed;
        case 'rejected':
          return JobStatus.rejected;
        case 'accepted':
          return JobStatus.accepted;
        case 'reportresolved':
        case 'report_resolved':
          return JobStatus.reportResolved;
        case 'reportunderreview':
        case 'report_under_review':
          return JobStatus.reportUnderReview;
        default:
          return JobStatus.active;
      }
    }

    String formatDate(String isoDate) {
      try {
        final date = DateTime.parse(isoDate);
        const months = [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر',
        ];
        return '${date.day} ${months[date.month - 1]}';
      } catch (_) {
        return isoDate;
      }
    }

    String formatTime(String isoDate) {
      try {
        final date = DateTime.parse(isoDate);
        final hour = date.hour.toString().padLeft(2, '0');
        final minute = date.minute.toString().padLeft(2, '0');
        final period = date.hour < 12 ? 'صباحاً' : 'مساءً';
        return '$hour:$minute $period';
      } catch (_) {
        return isoDate;
      }
    }

    String relativeTime(String isoDate) {
      try {
        final created = DateTime.parse(isoDate);
        final diff = DateTime.now().difference(created);

        if (diff.inMinutes < 60) return 'منذ قليل';
        if (diff.inHours < 24) {
          final h = diff.inHours;
          return 'منذ $h ${h == 1 ? 'ساعة' : 'ساعات'}';
        }

        final d = diff.inDays;
        return 'منذ $d ${d == 1 ? 'يوم' : 'أيام'}';
      } catch (_) {
        return 'منذ قليل';
      }
    }

    final effectivePrice =
        (pricePerHour?.amount?.toDouble() ??
        payment?.totalAmount?.toDouble() ??
        0);
    final workHours = dailyWorkHours?.toDouble() ?? 0;

    return JobModel(
      id: id,
      title: title ?? 'وظيفة',
      company: place ?? 'غير معروف',
      location: location?.address ?? 'المكان غير محدد',
      salary: (workHours * effectivePrice),
      postedAt: createdAt != null ? relativeTime(createdAt!) : 'منذ قليل',
      status: parseStatus(status),
      applicantsCount: requiredWorkers ?? 0,
      shiftTime: startDateTime != null
          ? formatTime(startDateTime!)
          : 'غير محدد',
      shiftDate: startDateTime != null
          ? formatDate(startDateTime!)
          : 'غير محدد',
      withoutExperience: (experienceLevel?.toLowerCase() == 'بدون خبرة'),
      shiftHours: dailyWorkHours ?? 0,
      imageUrl: null,
    );
  }
}
