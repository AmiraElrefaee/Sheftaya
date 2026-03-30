import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftModel {
  final String id;
  final String title;
  final String companyName;
  final String imageUrl;
  final double price;
  final DateTime startTime; // ✅ تأكدي أن الاسم startTime ليتوافق مع الـ UI
  final bool isWorkerArrived;
  final bool isEmployerConfirmed;

  ShiftModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.imageUrl,
    required this.price,
    required this.startTime,
    required this.isWorkerArrived,
    required this.isEmployerConfirmed,
  });

  factory ShiftModel.fromSnapshot(DocumentSnapshot doc, Map<String, dynamic> apiData) {
    Map<String, dynamic> fbData = doc.data() as Map<String, dynamic>;
    return ShiftModel(
      id: doc.id,
      title: apiData['title'] ?? 'N/A',
      companyName: apiData['companyName'] ?? 'N/A',
      price: apiData['price']?.toDouble() ?? 0.0,
      imageUrl: apiData['imageUrl'] ?? '',
      startTime: (apiData['startTime'] as DateTime), // ✅ التأكد من التحويل لـ DateTime
      isWorkerArrived: fbData['isWorkerArrived'] ?? false,
      isEmployerConfirmed: fbData['isEmployerConfirmed'] ?? false,
    );
  }
}