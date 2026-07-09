// lib/screens/helpdesk_main_screen.dart

import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import 'helpdesk_dashboard_screen.dart';
import 'helpdesk_list_ticket_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class HelpdeskMainScreen extends StatefulWidget {
  const HelpdeskMainScreen({super.key});

  @override
  State<HelpdeskMainScreen> createState() => _HelpdeskMainScreenState();
}

class _HelpdeskMainScreenState extends State<HelpdeskMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HelpdeskDashboardScreen(),
    HelpdeskListTicketScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: kPrimary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tiket Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
