// lib/models/notification_model.dart

class NotificationModel {
  final int id;
  final String title;
  final String body;
  bool isRead;
  final int? ticketId;
  final String? targetRole; // 'helpdesk', 'user', null = semua
  final String? targetUserId;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    this.ticketId,
    this.targetRole,
    this.targetUserId,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      ticketId: json['ticket_id'] != null
          ? (json['ticket_id'] is int
              ? json['ticket_id']
              : int.parse(json['ticket_id'].toString()))
          : null,
      targetRole: json['target_role'],
      targetUserId: json['target_user_id']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'is_read': isRead ? 1 : 0,
      'ticket_id': ticketId,
      'target_role': targetRole,
      'target_user_id': targetUserId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
