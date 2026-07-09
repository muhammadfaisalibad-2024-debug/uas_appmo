// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';
import 'create_ticket_screen.dart';
import 'detail_ticket_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
          );
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Buat Tiket'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
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
          const Text('Berikut ringkasan tiket kamu',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatCard(
                  label: 'Total Tiket',
                  value: total,
                  icon: Icons.confirmation_number,
                  color: kPrimary),
              _StatCard(
                  label: 'Open',
                  value: open,
                  icon: Icons.folder_open,
                  color: Colors.blue),
              _StatCard(
                  label: 'Assign',
                  value: assign,
                  icon: Icons.assignment_ind_outlined,
                  color: const Color(0xFF7C3AED)),
              _StatCard(
                  label: 'In Progress',
                  value: inProgress,
                  icon: Icons.sync,
                  color: Colors.orange),
              _StatCard(
                  label: 'Close',
                  value: close,
                  icon: Icons.check_circle_outline,
                  color: Colors.grey),
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
                        builder: (_) => DetailTicketScreen(ticket: t)),
                  );
                  setState(() {});
                },
              )),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 22),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: kPrimary.withOpacity(0.1),
          child: const Icon(Icons.confirmation_number,
              color: kPrimary, size: 20),
        ),
        title: Text(ticket.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('#${ticket.id} · ${ticket.priority.toUpperCase()}',
            style: const TextStyle(fontSize: 12)),
        trailing: StatusBadge(status: ticket.status),
      ),
    );
  }
}
