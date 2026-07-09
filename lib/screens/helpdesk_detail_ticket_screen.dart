// lib/screens/helpdesk_detail_ticket_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'tracking_screen.dart';

class HelpdeskDetailTicketScreen extends StatefulWidget {
  final TicketModel ticket;
  const HelpdeskDetailTicketScreen({super.key, required this.ticket});

  @override
  State<HelpdeskDetailTicketScreen> createState() =>
      _HelpdeskDetailTicketScreenState();
}

class _HelpdeskDetailTicketScreenState
    extends State<HelpdeskDetailTicketScreen> {
  final _replyCtrl = TextEditingController();

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  Future<void> _addReply() async {
    if (_replyCtrl.text.trim().isEmpty) return;
    await TicketService.addReply(
      ticket: widget.ticket,
      body: _replyCtrl.text.trim(),
      actor: currentUser,
    );
    if (!mounted) return;
    setState(() => _replyCtrl.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Balasan dikirim'),
          duration: Duration(seconds: 2)),
    );
  }

  void _finishTicket() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Selesaikan Tiket?'),
          ],
        ),
        content: const Text(
          'Apakah pekerjaan sudah selesai? Status tiket akan berubah otomatis menjadi CLOSE.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await TicketService.finishTicket(
                ticket: widget.ticket,
                actor: currentUser,
              );
              if (!mounted) return;
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Tiket berhasil diselesaikan — Status: CLOSE'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            child: const Text('Ya, Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final isActive = ticket.status == TicketStatus.inProgress;
    final publicComments =
        ticket.comments.where((c) => !c.isInternal).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket #${ticket.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timeline),
            tooltip: 'Tracking',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TrackingScreen(ticket: ticket)),
            ),
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
                  // Status
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                            label: 'Dilaporkan oleh',
                            value: ticket.createdByName),
                        const SizedBox(height: 8),
                        _InfoRow(
                            label: 'Dibuat pada',
                            value: formatDateTime(ticket.createdAt)),
                        const SizedBox(height: 8),
                        _InfoRow(
                            label: 'Ditugaskan ke',
                            value: ticket.assignedHelpdeskName ?? '-',
                            valueColor: Colors.blue),
                      ],
                    ),
                  ),

                  const Divider(height: 24),
                  const Text('Deskripsi Masalah',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(ticket.description,
                      style: const TextStyle(height: 1.5)),

                  const Divider(height: 32),
                  Text('Percakapan (${publicComments.length})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),

                  if (publicComments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Belum ada percakapan',
                            style:
                                TextStyle(color: Colors.grey.shade600)),
                      ),
                    )
                  else
                    ...publicComments.map((c) => _CommentItem(comment: c)),

                  // Tombol Finish
                  if (isActive) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _finishTicket,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Selesaikan Tiket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ] else if (ticket.status == TicketStatus.close) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text('Tiket ini sudah selesai',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input Reply
          if (isActive)
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
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
                      controller: _replyCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Tulis balasan...',
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
                    onPressed: _addReply,
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
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                child: Text(comment.userName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(formatDateTime(comment.createdAt),
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 10)),
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
          Text(comment.body, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}
