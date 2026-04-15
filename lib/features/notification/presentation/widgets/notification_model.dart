import 'package:sheftaya/features/notification/data/models/get_all_notifications/get_all_notifications_response.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool isNew;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.isNew,
  });

  factory NotificationModel.fromData(NotificationData data) {
    final createdAt = data.createdAt ?? DateTime.now();
    final isNew = DateTime.now().difference(createdAt).inHours < 24;

    return NotificationModel(
      id: data.id ?? '',
      title: data.title ?? '',
      body: data.message ?? '',
      date: createdAt,
      isNew: isNew,
    );
  }
}
