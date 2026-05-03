import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/widget/enums.dart';

class ShiftModel {
  final String id;
  final String title;
  final String companyName;
  final String imageUrl;
  final double price;
  final DateTime startTime;
  final ShiftStatus status;

  ShiftModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.imageUrl,
    required this.price,
    required this.startTime,
    required this.status,
  });

  // ✅ Getters مشتقة من الـ status
  bool get isWorkerArrived => status.index >= ShiftStatus.arrived.index;
  bool get isEmployerConfirmed => status.index >= ShiftStatus.arrivedApproved.index;

  factory ShiftModel.fromApi(Map<String, dynamic> data) {
    return ShiftModel(
      id: data['id'] ?? '',
      title: data['title'] ?? 'N/A',
      companyName: data['companyName'] ?? 'N/A',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      startTime: data['startTime'] is DateTime
          ? data['startTime']
          : DateTime.parse(data['startTime']),
      status: ShiftStatus.notStarted,
    );
  }

  ShiftModel copyWith({ShiftStatus? status}) {
    return ShiftModel(
      id: id,
      title: title,
      companyName: companyName,
      imageUrl: imageUrl,
      price: price,
      startTime: startTime,
      status: status ?? this.status,
    );
  }
}