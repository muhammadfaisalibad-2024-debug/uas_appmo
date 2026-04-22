// lib/data/dummy_data.dart

import '../models/ticket_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

// ─── Current User ──────────────────────────────────────────────────────
final dummyUser = UserModel(
  id: 1,
  name: 'Paisal Mahendra',
  email: 'paisal@student.unair.ac.id',
  role: 'user',
);

// ─── Tickets ───────────────────────────────────────────────────────────
final List<TicketModel> dummyTickets = [
  TicketModel(
    id: 1,
    title: 'Komputer Lab Tidak Bisa Menyala',
    description:
        'Komputer di Lab A nomor 12 tidak bisa menyala sejak pagi. Sudah dicoba dinyalakan beberapa kali namun tidak ada respon sama sekali. Lampu indikator power tidak menyala.',
    status: 'open',
    priority: 'high',
    assignedTo: null,
    comments: [
      CommentModel(
        id: 1,
        body: 'Terima kasih laporannya. Kami akan segera cek ke lapangan.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 20, 10, 30),
      ),
    ],
    createdAt: DateTime(2026, 4, 20, 9, 0),
    updatedAt: DateTime(2026, 4, 20, 10, 30),
  ),
  TicketModel(
    id: 2,
    title: 'Koneksi WiFi Lambat di Gedung B',
    description:
        'Koneksi WiFi di Gedung B lantai 2 sangat lambat sejak 3 hari lalu. Kecepatan download hanya 0.5 Mbps padahal biasanya 20 Mbps. Sudah restart perangkat tapi masih sama.',
    status: 'in_progress',
    priority: 'medium',
    assignedTo: 'Budi Santoso',
    comments: [
      CommentModel(
        id: 2,
        body: 'Sudah kami identifikasi, ada gangguan pada access point lantai 2.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 19, 14, 0),
      ),
      CommentModel(
        id: 3,
        body: 'Kapan kira-kira bisa normal kembali?',
        userName: 'Paisal Mahendra',
        createdAt: DateTime(2026, 4, 19, 15, 30),
      ),
      CommentModel(
        id: 4,
        body: 'Estimasi selesai besok siang, menunggu spare part.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 19, 16, 0),
      ),
    ],
    createdAt: DateTime(2026, 4, 18, 8, 0),
    updatedAt: DateTime(2026, 4, 19, 16, 0),
  ),
  TicketModel(
    id: 3,
    title: 'Printer Tidak Bisa Print',
    description:
        'Printer di ruang TU tidak bisa mencetak dokumen. Muncul error "Printer Offline" padahal printer sudah menyala dan terhubung ke jaringan.',
    status: 'resolved',
    priority: 'medium',
    assignedTo: 'Siti Rahma',
    comments: [
      CommentModel(
        id: 5,
        body: 'Masalah sudah diselesaikan. Driver printer diinstal ulang.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 17, 11, 0),
      ),
    ],
    createdAt: DateTime(2026, 4, 16, 13, 0),
    updatedAt: DateTime(2026, 4, 17, 11, 0),
  ),
  TicketModel(
    id: 4,
    title: 'Akses SISTER Tidak Bisa Login',
    description:
        'Tidak bisa login ke sistem SISTER menggunakan NIM dan password yang biasa digunakan. Sudah dicoba reset password namun email reset tidak masuk.',
    status: 'open',
    priority: 'high',
    assignedTo: null,
    comments: [],
    createdAt: DateTime(2026, 4, 21, 7, 30),
    updatedAt: DateTime(2026, 4, 21, 7, 30),
  ),
  TicketModel(
    id: 5,
    title: 'Proyektor Ruang 305 Error',
    description:
        'Proyektor di ruang 305 menampilkan gambar dengan warna yang aneh (kekuningan). Sudah coba restart namun tetap sama.',
    status: 'closed',
    priority: 'low',
    assignedTo: 'Andi Pratama',
    comments: [
      CommentModel(
        id: 6,
        body: 'Proyektor sudah diganti dengan unit baru.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 15, 9, 0),
      ),
    ],
    createdAt: DateTime(2026, 4, 14, 10, 0),
    updatedAt: DateTime(2026, 4, 15, 9, 0),
  ),
  TicketModel(
    id: 6,
    title: 'Email Kampus Tidak Bisa Diakses',
    description:
        'Email dengan domain @student.unair.ac.id tidak bisa diakses. Muncul pesan "Account Suspended" ketika mencoba login.',
    status: 'in_progress',
    priority: 'high',
    assignedTo: 'Budi Santoso',
    comments: [
      CommentModel(
        id: 7,
        body: 'Sedang kami investigasi, ada kemungkinan masalah pada server mail.',
        userName: 'Helpdesk IT',
        createdAt: DateTime(2026, 4, 21, 9, 0),
      ),
    ],
    createdAt: DateTime(2026, 4, 21, 8, 0),
    updatedAt: DateTime(2026, 4, 21, 9, 0),
  ),
];

// ─── Notifications ─────────────────────────────────────────────────────
final List<NotificationModel> dummyNotifications = [
  NotificationModel(
    id: 1,
    title: 'Tiket #6 Diperbarui',
    body: 'Helpdesk sedang menangani masalah email kampus kamu.',
    isRead: false,
    ticketId: 6,
    createdAt: DateTime(2026, 4, 21, 9, 5),
  ),
  NotificationModel(
    id: 2,
    title: 'Tiket #4 Diterima',
    body: 'Laporan kamu tentang SISTER sudah diterima tim helpdesk.',
    isRead: false,
    ticketId: 4,
    createdAt: DateTime(2026, 4, 21, 7, 35),
  ),
  NotificationModel(
    id: 3,
    title: 'Tiket #2 Dalam Proses',
    body: 'Masalah WiFi Gedung B sedang ditangani oleh Budi Santoso.',
    isRead: true,
    ticketId: 2,
    createdAt: DateTime(2026, 4, 19, 14, 5),
  ),
  NotificationModel(
    id: 4,
    title: 'Tiket #3 Selesai',
    body: 'Masalah printer di ruang TU sudah berhasil diselesaikan.',
    isRead: true,
    ticketId: 3,
    createdAt: DateTime(2026, 4, 17, 11, 5),
  ),
  NotificationModel(
    id: 5,
    title: 'Tiket #5 Ditutup',
    body: 'Tiket proyektor ruang 305 telah ditutup.',
    isRead: true,
    ticketId: 5,
    createdAt: DateTime(2026, 4, 15, 9, 5),
  ),
];
