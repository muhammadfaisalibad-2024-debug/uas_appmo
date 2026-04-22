import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../widgets/shared_widgets.dart';

class DetailTicketScreen extends StatefulWidget {
  final TicketModel ticket;
  const DetailTicketScreen({super.key, required this.ticket});

  @override
  State<DetailTicketScreen> createState() => _DetailTicketScreenState();
}

class _DetailTicketScreenState extends State<DetailTicketScreen> {
  final _commentCtrl = TextEditingController();
  late List<CommentModel> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.ticket.comments);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentCtrl.text.trim().isEmpty) return;
    setState(() {
      _comments.add(CommentModel(
        id: _comments.length + 100,
        body: _commentCtrl.text.trim(),
        userName: 'Paisal Mahendra',
        createdAt: DateTime.now(),
      ));
      _commentCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      appBar: AppBar(title: Text('Tiket #${ticket.id}')),
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
                  Text(
                    'Dibuat: ${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  if (ticket.assignedTo != null) ...[
                    const SizedBox(height: 4),
                    Text('Ditangani oleh: ${ticket.assignedTo}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ],

                  const Divider(height: 24),
                  const Text('Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(ticket.description,
                      style: const TextStyle(height: 1.5)),

                  const Divider(height: 32),
                  Text('Komentar (${_comments.length})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (_comments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada komentar',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ..._comments.map((c) => _CommentItem(comment: c)),
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

class _CommentItem extends StatelessWidget {
  final CommentModel comment;
  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    final isMe = comment.userName == 'Paisal Mahendra';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe
            ? kPrimary.withOpacity(0.08)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isMe ? kPrimary : Colors.grey,
                child: Text(
                  comment.userName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(comment.userName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
                style: const TextStyle(color: Colors.grey, fontSize: 11),
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
