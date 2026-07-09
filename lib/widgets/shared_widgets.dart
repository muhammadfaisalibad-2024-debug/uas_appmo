// lib/widgets/shared_widgets.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

const Color kPrimary = Color(0xFF2563EB);

// ─── Status Badge ────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case TicketStatus.open:
        return Colors.blue;
      case TicketStatus.assign:
        return const Color(0xFF7C3AED); // purple
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.close:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get _label {
    switch (status) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.assign:
        return 'Assign';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.close:
        return 'Close';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        _label,
        style:
            TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── Priority Badge ──────────────────────────────────────────────────────
class PriorityBadge extends StatelessWidget {
  final String priority;
  const PriorityBadge({super.key, required this.priority});

  Color get _color {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority.toUpperCase(),
        style:
            TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── App Bottom Nav (User) ───────────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: kPrimary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Tiket'),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Statistik'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil'),
      ],
    );
  }
}

// ─── Formatted Date Helper ───────────────────────────────────────────────
String formatDateTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '${dt.day}/${dt.month}/${dt.year} $h:$m';
}

String formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
