// lib/models/ticket_model.dart

// ─── Status Constants ───────────────────────────────────────────────────
class TicketStatus {
  static const String open = 'open';
  static const String assign = 'assign';
  static const String inProgress = 'in_progress';
  static const String close = 'close';

  static const List<String> all = [open, assign, inProgress, close];
}

// ─── Action Constants ───────────────────────────────────────────────────
class TicketAction {
  static const String created = 'Tiket dibuat';
  static const String assigned = 'Tiket diterima Admin';
  static const String helpdeskPicked = 'Assign ke Helpdesk';
  static const String replied = 'Menambahkan balasan';
  static const String finished = 'Pekerjaan selesai';
}

// ─── TicketHistory ──────────────────────────────────────────────────────
class TicketHistory {
  final String action;
  final String status;
  final String actorId;
  final String actorName;
  final String actorRole;
  final DateTime changedAt;
  final String note;

  TicketHistory({
    required this.action,
    required this.status,
    required this.actorId,
    required this.actorName,
    required this.actorRole,
    required this.changedAt,
    this.note = '',
  });

  factory TicketHistory.fromJson(Map<String, dynamic> json) {
    return TicketHistory(
      action: json['action'] ?? '',
      status: json['status'] ?? '',
      actorId: json['actor_id']?.toString() ?? '',
      actorName: json['actor_name'] ?? '',
      actorRole: json['actor_role'] ?? '',
      changedAt: json['changed_at'] != null
          ? DateTime.parse(json['changed_at'])
          : DateTime.now(),
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'status': status,
      'actor_id': actorId,
      'actor_name': actorName,
      'actor_role': actorRole,
      'changed_at': changedAt.toIso8601String(),
      'note': note,
    };
  }
}

// ─── TicketModel ────────────────────────────────────────────────────────
class TicketModel {
  final int id;
  final String title;
  final String description;
  String status;
  final String priority;
  final String createdById;
  final String createdByName;
  String? assignedHelpdeskId;
  String? assignedHelpdeskName;
  List<CommentModel> comments;
  List<TicketHistory> history;
  final DateTime createdAt;
  DateTime updatedAt;

  TicketModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdById,
    required this.createdByName,
    this.assignedHelpdeskId,
    this.assignedHelpdeskName,
    this.comments = const [],
    this.history = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'open',
      priority: json['priority'] ?? 'medium',
      createdById: json['created_by_id']?.toString() ?? '',
      createdByName: json['created_by_name'] ?? 'User',
      assignedHelpdeskId: json['assigned_helpdesk_id']?.toString(),
      assignedHelpdeskName: json['assigned_helpdesk_name'],
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((c) => CommentModel.fromJson(c))
              .toList()
          : [],
      history: json['history'] != null
          ? (json['history'] as List)
              .map((h) => TicketHistory.fromJson(h))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'created_by_id': createdById,
      'created_by_name': createdByName,
      'assigned_helpdesk_id': assignedHelpdeskId,
      'assigned_helpdesk_name': assignedHelpdeskName,
      'comments': comments.map((c) => c.toJson()).toList(),
      'history': history.map((h) => h.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ─── CommentModel ───────────────────────────────────────────────────────
class CommentModel {
  final int id;
  final String body;
  final String userName;
  final String userRole;
  final DateTime createdAt;
  final bool isInternal;

  CommentModel({
    required this.id,
    required this.body,
    required this.userName,
    this.userRole = 'user',
    required this.createdAt,
    this.isInternal = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      body: json['body'] ?? '',
      userName: json['user_name'] ?? 'Anonymous',
      userRole: json['user_role'] ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isInternal: json['is_internal'] == 1 || json['is_internal'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'user_name': userName,
      'user_role': userRole,
      'created_at': createdAt.toIso8601String(),
      'is_internal': isInternal ? 1 : 0,
    };
  }
}
