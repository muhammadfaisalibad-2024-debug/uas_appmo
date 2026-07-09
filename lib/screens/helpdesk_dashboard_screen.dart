// lib/screens/helpdesk_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'helpdesk_detail_ticket_screen.dart';

class HelpdeskDashboardScreen extends StatefulWidget {
  const HelpdeskDashboardScreen({super.key});

  @override
  State<HelpdeskDashboardScreen> createState() =>
      _HelpdeskDashboardScreenState();
}

class _HelpdeskDashboardScreenState extends State<HelpdeskDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final myTickets = TicketService.byHelpdeskId(currentUser.id);
    final active = myTickets
        .where((t) => t.status == TicketStatus.inProgress)
        .length;
    final done = myTickets
        .where((t) => t.status == TicketStatus.close)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Helpdesk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          Text(
            'Halo, ${currentUser.name.split(' ').first} 👋',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Tiket yang ditugaskan kepada Anda',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Total Ditugaskan',
                  value: myTickets.length,
                  icon: Icons.assignment,
                  color: kPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'In Progress',
                  value: active,
                  icon: Icons.sync,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Selesai',
                  value: done,
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Active tickets
          const Text('Tiket Aktif (In Progress)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...myTickets
              .where((t) => t.status == TicketStatus.inProgress)
              .map((t) => _TicketCard(
                    ticket: t,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                HelpdeskDetailTicketScreen(ticket: t)),
                      );
                      setState(() {});
                    },
                  )),

          if (myTickets
              .where((t) => t.status == TicketStatus.inProgress)
              .isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Tidak ada tiket aktif saat ini',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),

          if (done > 0) ...[
            const SizedBox(height: 16),
            const Text('Tiket Selesai',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...myTickets
                .where((t) => t.status == TicketStatus.close)
                .map((t) => _TicketCard(
                      ticket: t,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  HelpdeskDetailTicketScreen(ticket: t)),
                        );
                        setState(() {});
                      },
                    )),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value.toString(),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;
  const _TicketCard({required this.ticket, required this.onTap});

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tiket #${ticket.id}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  StatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(ticket.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              Row(
                children: [
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
