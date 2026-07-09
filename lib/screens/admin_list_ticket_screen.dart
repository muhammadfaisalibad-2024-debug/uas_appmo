// lib/screens/admin_list_ticket_screen.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'admin_detail_ticket_screen.dart';

class AdminListTicketScreen extends StatefulWidget {
  const AdminListTicketScreen({super.key});

  @override
  State<AdminListTicketScreen> createState() => _AdminListTicketScreenState();
}

class _AdminListTicketScreenState extends State<AdminListTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _statuses = [
    null,
    TicketStatus.open,
    TicketStatus.assign,
    TicketStatus.inProgress,
    TicketStatus.close,
  ];
  final _labels = ['Semua', 'Open', 'Assign', 'In Progress', 'Close'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tiket'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _statuses.map((status) {
          final tickets = TicketService.byStatus(status);
          if (tickets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Tidak ada tiket',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tickets.length,
            itemBuilder: (_, i) => _AdminTicketItem(
              ticket: tickets[i],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AdminDetailTicketScreen(ticket: tickets[i]),
                  ),
                );
                setState(() {});
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AdminTicketItem extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;
  const _AdminTicketItem({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tiket #${ticket.id}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(ticket.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  PriorityBadge(priority: ticket.priority),
                  const SizedBox(width: 8),
                  const Icon(Icons.person_outline,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      ticket.assignedHelpdeskName ?? 'Belum di-assign',
                      style: TextStyle(
                          fontSize: 11,
                          color: ticket.assignedHelpdeskName == null
                              ? Colors.red
                              : Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
