// lib/screens/detail_ticket_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'tracking_screen.dart';

class DetailTicketScreen extends StatefulWidget {
  final TicketModel ticket;
  const DetailTicketScreen({super.key, required this.ticket});

  @override
  State<DetailTicketScreen> createState() => _DetailTicketScreenState();
}

class _DetailTicketScreenState extends State<DetailTicketScreen> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    if (_commentCtrl.text.trim().isEmpty) return;
    await TicketService.addReply(
      ticket: widget.ticket,
      body: _commentCtrl.text.trim(),
      actor: currentUser,
    );
    if (!mounted) return;
    setState(() => _commentCtrl.clear());
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final publicComments =
        ticket.comments.where((c) => !c.isInternal).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket #${ticket.id}'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TrackingScreen(ticket: ticket)),
            ),
            icon: const Icon(Icons.timeline, color: Colors.white, size: 18),
            label: const Text('Tracking',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge row
                  Row(
                    children: [
                      StatusBadge(status: ticket.status),
                      const SizedBox(width: 8),
                      PriorityBadge(priority: ticket.priority),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(ticket.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),

                  // Info
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                            label: 'Dibuat',
                            value: formatDateTime(ticket.createdAt)),
                        const SizedBox(height: 6),
                        _InfoRow(
                          label: 'Ditangani oleh',
                          value: ticket.assignedHelpdeskName ??
                              'Menunggu penanganan',
                          valueColor: ticket.assignedHelpdeskName == null
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24),
                  const Text('Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(ticket.description,
                      style: const TextStyle(height: 1.5)),

                  const Divider(height: 32),
                  Text('Komentar (${publicComments.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (publicComments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada komentar',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...publicComments.map((c) => _CommentItem(comment: c)),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input komentar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    maxLines: 2,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: valueColor)),
      ],
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentModel comment;
  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final isHelpdesk = comment.userRole == 'helpdesk';
    final isAdmin = comment.userRole == 'admin';
    final color = isHelpdesk
        ? kPrimary
        : (isAdmin ? Colors.teal : Colors.grey.shade600);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: color,
                child: Text(
                  comment.userName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      formatDateTime(comment.createdAt),
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (isHelpdesk || isAdmin)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isHelpdesk ? 'Helpdesk' : 'Admin',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.body),
        ],
      ),
    );
  }
}
