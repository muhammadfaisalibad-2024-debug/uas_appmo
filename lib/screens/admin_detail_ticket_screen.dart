// lib/screens/admin_detail_ticket_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'tracking_screen.dart';

class AdminDetailTicketScreen extends StatefulWidget {
  final TicketModel ticket;
  const AdminDetailTicketScreen({super.key, required this.ticket});

  @override
  State<AdminDetailTicketScreen> createState() =>
      _AdminDetailTicketScreenState();
}

class _AdminDetailTicketScreenState extends State<AdminDetailTicketScreen> {
  final _responseCtrl = TextEditingController();

  @override
  void dispose() {
    _responseCtrl.dispose();
    super.dispose();
  }

  // ─── One-flow Assign ────────────────────────────────────────────────
  void _showAssignDialog() {
    final helpdesks = dummyHelpdesks;
    UserModel? selected;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.person_add, color: kPrimary, size: 20),
              SizedBox(width: 8),
              Text('Pilih Helpdesk'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Setelah helpdesk dipilih, status tiket akan otomatis berubah ke IN PROGRESS.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ...helpdesks.map((h) => RadioListTile<UserModel>(
                      value: h,
                      groupValue: selected,
                      onChanged: (v) => setLocal(() => selected = v),
                      title: Text(h.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(h.email,
                          style: const TextStyle(fontSize: 11)),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: selected == null
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      _executeAssign(selected!);
                    },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _executeAssign(UserModel helpdesk) async {
    await TicketService.assignTicket(
      ticket: widget.ticket,
      helpdesk: helpdesk,
      actor: currentUser,
    );
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Tiket berhasil di-assign ke ${helpdesk.name} — Status: IN PROGRESS'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _addResponse() async {
    if (_responseCtrl.text.trim().isEmpty) return;
    await TicketService.addReply(
      ticket: widget.ticket,
      body: _responseCtrl.text.trim(),
      actor: currentUser,
    );
    if (!mounted) return;
    setState(() => _responseCtrl.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Respon ditambahkan'),
          duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;
    final isAssignable = ticket.status == TicketStatus.open ||
        ticket.status == TicketStatus.assign;
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
                  // Status & Priority
                  Row(
                    children: [
                      StatusBadge(status: ticket.status),
                      const SizedBox(width: 8),
                      PriorityBadge(priority: ticket.priority),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
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
                          label: 'Dibuat oleh',
                          value: ticket.createdByName,
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Dibuat pada',
                          value: formatDateTime(ticket.createdAt),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          label: 'Ditangani oleh',
                          value: ticket.assignedHelpdeskName ?? 'Belum di-assign',
                          valueColor: ticket.assignedHelpdeskName == null
                              ? Colors.red
                              : Colors.green,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 24),

                  // Description
                  const Text('Deskripsi Masalah',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(ticket.description,
                      style: const TextStyle(height: 1.5)),

                  const Divider(height: 32),

                  // Comments
                  Text('Respon (${publicComments.length})',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),

                  if (publicComments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Belum ada respon',
                            style:
                                TextStyle(color: Colors.grey.shade600)),
                      ),
                    )
                  else
                    ...publicComments.map((c) => _CommentItem(comment: c)),

                  // Assign Button
                  if (isAssignable) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showAssignDialog,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Assign ke Helpdesk'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Input Respon
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
                    controller: _responseCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tulis respon publik...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      helperText: 'Akan dilihat oleh user',
                    ),
                    maxLines: 2,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addResponse,
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
              color: valueColor,
            )),
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
    final color = isHelpdesk ? kPrimary : (isAdmin ? Colors.teal : Colors.grey);

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
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    Text(
                      formatDateTime(comment.createdAt),
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isHelpdesk ? 'Helpdesk' : (isAdmin ? 'Admin' : 'User'),
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
