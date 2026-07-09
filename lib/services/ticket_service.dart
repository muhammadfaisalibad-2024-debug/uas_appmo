// lib/services/ticket_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';

class TicketService {
  // Use http://10.0.2.2:8000/api for Android Emulator.
  // Use http://localhost:8000/api for Windows / Web / iOS.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://localhost:8000/api';
    }
  }

  // ─── Cache & Refresh ────────────────────────────────────────────────

  static Future<void> refreshData() async {
    try {
      // 1. Fetch tickets
      final ticketsRes = await http.get(Uri.parse('$baseUrl/tickets'));
      if (ticketsRes.statusCode == 200) {
        final List<dynamic> ticketsJson = jsonDecode(ticketsRes.body);
        final fetchedTickets =
            ticketsJson.map((t) => TicketModel.fromJson(t)).toList();
        dummyTickets.clear();
        dummyTickets.addAll(fetchedTickets);
      }

      // 2. Fetch notifications
      final notifsRes = await http.get(Uri.parse('$baseUrl/notifications'));
      if (notifsRes.statusCode == 200) {
        final List<dynamic> notifsJson = jsonDecode(notifsRes.body);
        final fetchedNotifs =
            notifsJson.map((n) => NotificationModel.fromJson(n)).toList();
        dummyNotifications.clear();
        dummyNotifications.addAll(fetchedNotifs);
      }

      // 3. Fetch helpdesks to update dummyUsers list
      final helpdesksRes =
          await http.get(Uri.parse('$baseUrl/users/helpdesks'));
      if (helpdesksRes.statusCode == 200) {
        final List<dynamic> helpdesksJson = jsonDecode(helpdesksRes.body);
        final fetchedHelpdesks =
            helpdesksJson.map((h) => UserModel.fromJson(h)).toList();

        // Keep local admin and user, but replace helpdesks with the server ones
        dummyUsers.removeWhere((u) => u.role == 'helpdesk');
        dummyUsers.addAll(fetchedHelpdesks);
      }
    } catch (e) {
      debugPrint('Error refreshing data from API: $e');
    }
  }

  // ─── Sync Count & Filters (Reads Cache) ─────────────────────────────

  static int countTotal() => dummyTickets.length;
  static int countOpen() =>
      dummyTickets.where((t) => t.status == TicketStatus.open).length;
  static int countAssign() =>
      dummyTickets.where((t) => t.status == TicketStatus.assign).length;
  static int countInProgress() =>
      dummyTickets.where((t) => t.status == TicketStatus.inProgress).length;
  static int countClose() =>
      dummyTickets.where((t) => t.status == TicketStatus.close).length;

  static List<TicketModel> byStatus(String? status) => status == null
      ? List.from(dummyTickets)
      : dummyTickets.where((t) => t.status == status).toList();

  static List<TicketModel> byHelpdeskId(String helpdeskId) => dummyTickets
      .where((t) => t.assignedHelpdeskId == helpdeskId)
      .toList();

  // ─── Authentication ──────────────────────────────────────────────────

  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (res.statusCode == 200) {
        currentUser = UserModel.fromJson(jsonDecode(res.body));
        await refreshData();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
    return false;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 217) {
        currentUser = UserModel.fromJson(jsonDecode(res.body));
        await refreshData();
        return true;
      }
    } catch (e) {
      debugPrint('Register error: $e');
    }
    return false;
  }

  // ─── Operations (Calls API and then refreshes Cache) ─────────────────

  static Future<void> createTicket({
    required String title,
    required String description,
    required String priority,
    required UserModel creator,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tickets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'priority': priority,
          'created_by_id': creator.id,
        }),
      );
      if (res.statusCode == 200 || res.statusCode == 217) {
        await refreshData();
      }
    } catch (e) {
      debugPrint('Create ticket error: $e');
    }
  }

  static Future<void> assignTicket({
    required TicketModel ticket,
    required UserModel helpdesk,
    required UserModel actor,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tickets/${ticket.id}/assign'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'assigned_helpdesk_id': helpdesk.id,
          'actor_id': actor.id,
        }),
      );
      if (res.statusCode == 200) {
        await refreshData();
      }
    } catch (e) {
      debugPrint('Assign ticket error: $e');
    }
  }

  static Future<void> finishTicket({
    required TicketModel ticket,
    required UserModel actor,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tickets/${ticket.id}/finish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'actor_id': actor.id,
        }),
      );
      if (res.statusCode == 200) {
        await refreshData();
      }
    } catch (e) {
      debugPrint('Finish ticket error: $e');
    }
  }

  static Future<void> addReply({
    required TicketModel ticket,
    required String body,
    required UserModel actor,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/tickets/${ticket.id}/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'body': body,
          'actor_id': actor.id,
        }),
      );
      if (res.statusCode == 200) {
        await refreshData();
      }
    } catch (e) {
      debugPrint('Add reply error: $e');
    }
  }

  // ─── Notifications (Reads Cache) ────────────────────────────────────

  static List<NotificationModel> notificationsFor(UserModel user) =>
      dummyNotifications
          .where((n) =>
              (n.targetRole == user.role || n.targetUserId == user.id))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  static int unreadCountFor(UserModel user) =>
      notificationsFor(user).where((n) => !n.isRead).length;

  static Future<void> markRead(NotificationModel n) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/notifications/${n.id}/read'),
      );
      if (res.statusCode == 200) {
        n.isRead = true;
        await refreshData();
      }
    } catch (e) {
      debugPrint('Mark read error: $e');
    }
  }

  static Future<void> markAllRead(List<NotificationModel> notifs) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/notifications/read-all'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': currentUser.id,
          'role': currentUser.role,
        }),
      );
      if (res.statusCode == 200) {
        for (final n in notifs) {
          n.isRead = true;
        }
        await refreshData();
      }
    } catch (e) {
      debugPrint('Mark all read error: $e');
    }
  }
}
