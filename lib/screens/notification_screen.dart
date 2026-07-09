// lib/screens/notification_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/notification_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> get _myNotifications =>
      TicketService.notificationsFor(currentUser);

  Future<void> _markRead(NotificationModel n) async {
    await TicketService.markRead(n);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _markAllRead() async {
    await TicketService.markAllRead(_myNotifications);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _myNotifications;
    final unread = notifs.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Tandai Semua Dibaca',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Tidak ada notifikasi',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    color: kPrimary.withOpacity(0.08),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: kPrimary, size: 16),
                        const SizedBox(width: 8),
                        Text('$unread pesan belum dibaca',
                            style: const TextStyle(
                                color: kPrimary, fontSize: 13)),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: notifs.length,
                    itemBuilder: (_, i) => _NotifItem(
                      notif: notifs[i],
                      onTap: () => _markRead(notifs[i]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;
  const _NotifItem({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: notif.isRead
          ? null
          : kPrimary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: notif.isRead
              ? Colors.grey.shade200
              : kPrimary.withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (notif.isRead ? Colors.grey : kPrimary)
                      .withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notif.isRead
                      ? Icons.notifications
                      : Icons.notifications_active,
                  color: notif.isRead ? Colors.grey : kPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notif.title,
                              style: TextStyle(
                                fontWeight: notif.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: kPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notif.body,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(
                      formatDateTime(notif.createdAt),
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
