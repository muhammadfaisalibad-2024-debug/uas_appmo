// lib/screens/list_ticket_screen.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'create_ticket_screen.dart';
import 'detail_ticket_screen.dart';

class ListTicketScreen extends StatefulWidget {
  const ListTicketScreen({super.key});

  @override
  State<ListTicketScreen> createState() => _ListTicketScreenState();
}

class _ListTicketScreenState extends State<ListTicketScreen>
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
        title: const Text('Daftar Tiket'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          );
          setState(() {});
        },
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
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
            itemBuilder: (_, i) => _TicketItem(
              ticket: tickets[i],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          DetailTicketScreen(ticket: tickets[i])),
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

class _TicketItem extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;
  const _TicketItem({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(ticket.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('#${ticket.id}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 10),
                  PriorityBadge(priority: ticket.priority),
                  const Spacer(),
                  const Icon(Icons.access_time,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    formatDate(ticket.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
