// lib/models/notification_model.dart

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final int? ticketId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.ticketId,
    required this.createdAt,
  });
}
