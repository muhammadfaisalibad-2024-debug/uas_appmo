// lib/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import '../data/dummy_data.dart';
import 'admin_detail_ticket_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final total = TicketService.countTotal();
    final open = TicketService.countOpen();
    final assign = TicketService.countAssign();
    final inProgress = TicketService.countInProgress();
    final close = TicketService.countClose();
    final recent = dummyTickets.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
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
          const Text('Ringkasan tiket dan aktivitas helpdesk',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // Total Card
          _TotalCard(total: total),
          const SizedBox(height: 16),

          // Status Grid
          const Text('Status Tiket',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 100,
            children: [
              _StatCard(
                label: 'Open',
                value: open,
                icon: Icons.folder_open,
                color: Colors.blue,
              ),
              _StatCard(
                label: 'Assign',
                value: assign,
                icon: Icons.assignment_ind_outlined,
                color: const Color(0xFF7C3AED),
              ),
              _StatCard(
                label: 'In Progress',
                value: inProgress,
                icon: Icons.sync,
                color: Colors.orange,
              ),
              _StatCard(
                label: 'Close',
                value: close,
                icon: Icons.check_circle_outline,
                color: Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text('Tiket Terbaru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          ...recent.map((t) => _RecentTicketCard(
                ticket: t,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AdminDetailTicketScreen(ticket: t)),
                  );
                  setState(() {});
                },
              )),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int total;
  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number,
              color: Colors.white, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Tiket',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(total.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold)),
            ],
          ),
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

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value.toString(),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;
  const _RecentTicketCard({required this.ticket, required this.onTap});

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
              const SizedBox(height: 6),
              Text(ticket.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(
                children: [
                  PriorityBadge(priority: ticket.priority),
                  const SizedBox(width: 8),
                  const Icon(Icons.person_outline,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    ticket.assignedHelpdeskName ?? 'Belum di-assign',
                    style: TextStyle(
                        fontSize: 11,
                        color: ticket.assignedHelpdeskName == null
                            ? Colors.red
                            : Colors.grey),
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
