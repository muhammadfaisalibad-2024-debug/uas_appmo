// lib/screens/statistik_screen.dart

import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/shared_widgets.dart';

class StatistikScreen extends StatelessWidget {
  const StatistikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = TicketService.countTotal();
    final open = TicketService.countOpen();
    final assign = TicketService.countAssign();
    final inProgress = TicketService.countInProgress();
    final close = TicketService.countClose();

    final data = [
      _StatData('Open', open, Colors.blue, TicketStatus.open),
      _StatData('Assign', assign, const Color(0xFF7C3AED), TicketStatus.assign),
      _StatData('In Progress', inProgress, Colors.orange, TicketStatus.inProgress),
      _StatData('Close', close, Colors.green, TicketStatus.close),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header total
          Container(
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
                const Icon(Icons.bar_chart, color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Tiket',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14)),
                    Text(total.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Distribusi Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Progress bars
          ...data.map((d) => _StatBar(data: d, total: total)),

          const SizedBox(height: 28),
          const Text('Distribusi Prioritas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _PrioritySection(),

          const SizedBox(height: 28),
          const Text('Ringkasan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Summary cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 90,
            children: data.map((d) => _SummaryCard(data: d)).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ────────────────────────────────────────────────────────
class _StatData {
  final String label;
  final int count;
  final Color color;
  final String status;
  _StatData(this.label, this.count, this.color, this.status);
}

// ─── Progress Bar Widget ───────────────────────────────────────────────
class _StatBar extends StatelessWidget {
  final _StatData data;
  final int total;
  const _StatBar({required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : data.count / total;
    final pctStr = total == 0 ? '0%' : '${(pct * 100).round()}%';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: data.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(data.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  Text(data.count.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: data.color,
                          fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(pctStr,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 12,
              backgroundColor: data.color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(data.color),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Priority Section ─────────────────────────────────────────────────
class _PrioritySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tickets = TicketService.byStatus(null);
    final high = tickets.where((t) => t.priority == 'high').length;
    final medium = tickets.where((t) => t.priority == 'medium').length;
    final low = tickets.where((t) => t.priority == 'low').length;
    final total = tickets.length;

    final pData = [
      _StatData('High', high, Colors.red, ''),
      _StatData('Medium', medium, Colors.orange, ''),
      _StatData('Low', low, Colors.green, ''),
    ];

    return Column(
      children: pData
          .map((d) => _StatBar(data: d, total: total))
          .toList(),
    );
  }
}

// ─── Summary Card ──────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final _StatData data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: data.color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusBadge(status: data.status),
            const SizedBox(height: 8),
            Text(data.count.toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: data.color)),
          ],
        ),
      ),
    );
  }
}
