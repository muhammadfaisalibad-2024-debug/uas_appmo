// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../widgets/shared_widgets.dart';
import '../services/ticket_service.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';
import 'main_screen.dart';
import 'admin_main_screen.dart';
import 'helpdesk_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailCtrl.text.trim().toLowerCase();
    final pass = _passCtrl.text;

    final success = await TicketService.login(email, pass);

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isLoading = false;
        _error = 'Email atau password salah';
      });
      return;
    }

    final user = currentUser;

    Widget screen;
    if (user.role == 'admin') {
      screen = const AdminMainScreen();
    } else if (user.role == 'helpdesk') {
      screen = const HelpdeskMainScreen();
    } else {
      screen = const MainScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Center(
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    size: 64,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text('Selamat Datang',
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                const Center(
                  child: Text('E-Ticketing Helpdesk',
                      style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 28),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ResetPasswordScreen()),
                    ),
                    child: const Text('Lupa Password?'),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 8),
                      Text(_error!,
                          style: const TextStyle(color: Colors.red)),
                    ]),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Masuk',
                          style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun? '),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      ),
                      child: const Text('Daftar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
