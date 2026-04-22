// lib/models/ticket_model.dart

class TicketModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String? assignedTo;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assignedTo,
    this.comments = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}

class CommentModel {
  final int id;
  final String body;
  final String userName;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.body,
    required this.userName,
    required this.createdAt,
  });
}
