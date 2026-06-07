import 'dart:developer';
import '../../presentation/widget/enums.dart';
import 'package:sheftaya/features/worker/my_application_jobs/data/models/my_jobs_response.dart';

class ShiftModel {
  final String id;
  final String title;
  final String companyName;
  final String imageUrl;
  final double price;
  final DateTime startTime;
  final ShiftStatus status;
  final String appId;
  final UserRole role;

  ShiftModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.imageUrl,
    required this.price,
    required this.startTime,
    required this.status,
    required this.appId,
    required this.role,
  });

  // ✅ Factory constructor من MyJobItem
  factory ShiftModel.fromMyJobItem({
    required MyJobItem item,
    required UserRole role,
  }) {
    final job = item.job;
    final startDateTime = job?.startDateTime != null
        ? DateTime.parse(job!.startDateTime!)
        : DateTime.now();

    return ShiftModel(
      id: job?.id ?? '',
      appId: item.applicationId ?? '',
      title: job?.title ?? '',
      companyName: job?.companyDetails?.companyName ?? job?.place ?? '',
      imageUrl: job?.jobImages?.isNotEmpty == true
          ? job!.jobImages!.first
          : '',
      price: (job?.pricePerHour?.amount ?? 0).toDouble(),
      startTime: startDateTime,
      status: ShiftStatus.notStarted,
      role: role,
    );
  }

  // ✅ Factory constructor من البيانات الأساسية
  factory ShiftModel.fromBasic({
    required String jobId,
    required String appId,
    required String title,
    required String companyName,
    required String imageUrl,
    required double price,
    required DateTime startTime,
    required UserRole role,
    ShiftStatus status = ShiftStatus.notStarted,
  }) {
    return ShiftModel(
      id: jobId,
      appId: appId,
      title: title,
      companyName: companyName,
      imageUrl: imageUrl,
      price: price,
      startTime: startTime,
      status: status,
      role: role,
    );
  }

  // ✅ Getters
  bool get isWorkerArrived =>
      status == ShiftStatus.arrived ||
          status == ShiftStatus.arrivedApproved ||
          status == ShiftStatus.inProgress ||
          status == ShiftStatus.completed;

  bool get isEmployerConfirmed =>
      status == ShiftStatus.arrivedApproved ||
          status == ShiftStatus.inProgress ||
          status == ShiftStatus.completed;

  // ✅ من API
  factory ShiftModel.fromApi(Map<String, dynamic> data) {
    final statusValue = data['status'];
    ShiftStatus parsedStatus;

    if (statusValue is ShiftStatus) {
      parsedStatus = statusValue;
    } else if (statusValue is String) {
      parsedStatus = ShiftStatusExtension.fromString(statusValue);
    } else {
      parsedStatus = ShiftStatus.notStarted;
    }

    return ShiftModel(
      id: data['id'] ?? '',
      appId: data['appId'] ?? '',
      title: data['title'] ?? 'N/A',
      companyName: data['companyName'] ?? 'N/A',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      startTime: data['startTime'] is DateTime
          ? data['startTime']
          : DateTime.parse(data['startTime']),
      status: parsedStatus,
      role: data['role'] == 'employer' ? UserRole.employer : UserRole.worker,
    );
  }

  ShiftModel copyWith({ShiftStatus? status}) {
    return ShiftModel(
      id: id,
      appId: appId,
      title: title,
      companyName: companyName,
      imageUrl: imageUrl,
      price: price,
      startTime: startTime,
      status: status ?? this.status,
      role: role,
    );
  }

  // ✅ تحويل إلى Map للتمرير بين الشاشات
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appId': appId,
      'title': title,
      'companyName': companyName,
      'imageUrl': imageUrl,
      'price': price,
      'startTime': startTime.toIso8601String(),
      'status': status.name,
      'role': role.name,
    };
  }

  // ✅ إنشاء من Map
  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    return ShiftModel(
      id: map['id'] ?? '',
      appId: map['appId'] ?? '',
      title: map['title'] ?? '',
      companyName: map['companyName'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      startTime: DateTime.parse(map['startTime']),
      status: ShiftStatusExtension.fromString(map['status'] ?? 'not_started'),
      role: map['role'] == 'employer' ? UserRole.employer : UserRole.worker,
    );
  }
}