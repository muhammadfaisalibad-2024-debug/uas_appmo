import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../main.dart';
import '../widgets/shared_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MyApp.of(context).isDark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: kPrimary,
                  child: Text(
                    dummyUser.name[0].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(dummyUser.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(dummyUser.email,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('User',
                      style: TextStyle(
                          color: kPrimary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          const Divider(),

          // Settings
          _SectionLabel('Pengaturan'),
          SwitchListTile(
            value: isDark,
            onChanged: (_) => MyApp.of(context).toggleTheme(),
            title: const Text('Mode Gelap'),
            subtitle: const Text('Aktifkan tampilan dark mode'),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          ),

          const Divider(),
          _SectionLabel('Informasi Akun'),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Role'),
            trailing: Text(dummyUser.role.toUpperCase(),
                style: const TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            trailing: Text(dummyUser.email,
                style:
                    const TextStyle(color: Colors.grey, fontSize: 13)),
          ),

          const Divider(),
          _SectionLabel('Aktivitas'),
          ListTile(
            leading: const Icon(Icons.confirmation_number_outlined),
            title: const Text('Total Tiket Dibuat'),
            trailing: Text('${dummyTickets.length}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline,
                color: Colors.green),
            title: const Text('Tiket Selesai'),
            trailing: Text(
              dummyTickets
                  .where((t) => t.status == 'resolved' || t.status == 'closed')
                  .length
                  .toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green),
            ),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Keluar',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Keluar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 0.5),
      ),
    );
  }
}
