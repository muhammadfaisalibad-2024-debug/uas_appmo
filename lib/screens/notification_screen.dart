import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/notification_model.dart';
import '../widgets/shared_widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> _notifs;

  @override
  void initState() {
    super.initState();
    _notifs = List.from(dummyNotifications);
  }

  void _markAllRead() {
    setState(() {
      _notifs = _notifs
          .map((n) => NotificationModel(
                id: n.id,
                title: n.title,
                body: n.body,
                isRead: true,
                ticketId: n.ticketId,
                createdAt: n.createdAt,
              ))
          .toList();
    });
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _unreadCount > 0
              ? 'Notifikasi ($_unreadCount)'
              : 'Notifikasi',
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Baca Semua',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _notifs.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Tidak ada notifikasi',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.separated(
              itemCount: _notifs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final n = _notifs[i];
                return ListTile(
                  tileColor: n.isRead
                      ? null
                      : Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  leading: CircleAvatar(
                    backgroundColor: n.isRead
                        ? Colors.grey.shade200
                        : kPrimary.withOpacity(0.15),
                    child: Icon(
                      Icons.notifications,
                      color: n.isRead ? Colors.grey : kPrimary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    n.title,
                    style: TextStyle(
                      fontWeight:
                          n.isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.body,
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(
                        '${n.createdAt.day}/${n.createdAt.month}/${n.createdAt.year} ${n.createdAt.hour.toString().padLeft(2, '0')}:${n.createdAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: !n.isRead
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: kPrimary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _notifs[i] = NotificationModel(
                        id: n.id,
                        title: n.title,
                        body: n.body,
                        isRead: true,
                        ticketId: n.ticketId,
                        createdAt: n.createdAt,
                      );
                    });
                  },
                );
              },
            ),
    );
  }
}
