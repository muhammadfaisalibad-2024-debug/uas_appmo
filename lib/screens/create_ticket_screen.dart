// lib/screens/create_ticket_screen.dart

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../services/ticket_service.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _priority = 'medium';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Buat tiket via TicketService
    await TicketService.createTicket(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      priority: _priority,
      creator: currentUser,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Tiket berhasil dibuat! Status: OPEN'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Tiket Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tiket baru akan otomatis berstatus OPEN.',
                        style: TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul Tiket',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Masalah',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              const Text('Prioritas',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _PriorityChip(
                    label: 'Low',
                    color: Colors.green,
                    selected: _priority == 'low',
                    onTap: () => setState(() => _priority = 'low'),
                  ),
                  const SizedBox(width: 8),
                  _PriorityChip(
                    label: 'Medium',
                    color: Colors.orange,
                    selected: _priority == 'medium',
                    onTap: () => setState(() => _priority = 'medium'),
                  ),
                  const SizedBox(width: 8),
                  _PriorityChip(
                    label: 'High',
                    color: Colors.red,
                    selected: _priority == 'high',
                    onTap: () => setState(() => _priority = 'high'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Upload simulasi
              const Text('Lampiran (Opsional)',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file, size: 32, color: Colors.grey),
                    SizedBox(height: 6),
                    Text('Tap untuk upload gambar',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),

              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Kirim Tiket',
                        style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PriorityChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
              color: selected ? color : Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
