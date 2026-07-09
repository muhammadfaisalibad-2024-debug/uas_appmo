// lib/screens/tracking_screen.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../widgets/shared_widgets.dart';

class TrackingScreen extends StatelessWidget {
  final TicketModel ticket;
  const TrackingScreen({super.key, required this.ticket});

  Color _statusColor(String status) {
    switch (status) {
      case TicketStatus.open:
        return Colors.blue;
      case TicketStatus.assign:
        return const Color(0xFF7C3AED);
      case TicketStatus.inProgress:
        return Colors.orange;
      case TicketStatus.close:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case TicketStatus.open:
        return Icons.folder_open;
      case TicketStatus.assign:
        return Icons.assignment_ind;
      case TicketStatus.inProgress:
        return Icons.sync;
      case TicketStatus.close:
        return Icons.check_circle;
      default:
        return Icons.circle;
    }
  }

  String _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return '🛡️';
      case 'helpdesk':
        return '🔧';
      default:
        return '👤';
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ticket.history;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Tiket #${ticket.id}'),
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    StatusBadge(status: ticket.status),
                    const SizedBox(width: 8),
                    PriorityBadge(priority: ticket.priority),
                    const Spacer(),
                    Text('${history.length} aktivitas',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Timeline
          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat',
                        style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: history.length,
                    itemBuilder: (_, i) {
                      final h = history[i];
                      final isLast = i == history.length - 1;
                      final color = _statusColor(h.status);

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline line + dot
                            SizedBox(
                              width: 40,
                              child: Column(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: color, width: 2),
                                    ),
                                    child: Icon(_statusIcon(h.status),
                                        color: color, size: 18),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Content
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: isLast ? 0 : 20),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: color.withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Action + Status
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(h.action,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 14)),
                                          ),
                                          StatusBadge(status: h.status),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Actor
                                      Row(
                                        children: [
                                          Text(_roleIcon(h.actorRole),
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                          const SizedBox(width: 6),
                                          Text(h.actorName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(h.actorRole,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Time
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              size: 12,
                                              color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            formatDateTime(h.changedAt),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11),
                                          ),
                                        ],
                                      ),

                                      // Note
                                      if (h.note.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            h.note,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
