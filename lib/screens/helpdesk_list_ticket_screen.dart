// lib/screens/helpdesk_list_ticket_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'helpdesk_detail_ticket_screen.dart';

class HelpdeskListTicketScreen extends StatefulWidget {
  const HelpdeskListTicketScreen({super.key});

  @override
  State<HelpdeskListTicketScreen> createState() =>
      _HelpdeskListTicketScreenState();
}

class _HelpdeskListTicketScreenState extends State<HelpdeskListTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _labels = ['Semua', 'In Progress', 'Close'];

  List<TicketModel> _filterTickets(String? status) {
    final all = TicketService.byHelpdeskId(currentUser.id);
    if (status == null) return all;
    return all.where((t) => t.status == status).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _labels.length, vsync: this);
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
        title: const Text('Tiket Saya'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: _labels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(null),
          _buildList(TicketStatus.inProgress),
          _buildList(TicketStatus.close),
        ],
      ),
    );
  }

  Widget _buildList(String? status) {
    final tickets = _filterTickets(status);
    if (tickets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Tidak ada tiket', style: TextStyle(color: Colors.grey)),
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
                    HelpdeskDetailTicketScreen(ticket: tickets[i])),
          );
          setState(() {});
        },
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
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
                  const Icon(Icons.person_outline,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(ticket.createdByName,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
