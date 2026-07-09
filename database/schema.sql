-- helpdesk.sql
-- Database schema and seed data for E-Ticketing Helpdesk (UAS Mobile Apps)

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `ticket`;
DROP TABLE IF EXISTS `ticket_history`;
DROP TABLE IF EXISTS `comment`;
DROP TABLE IF EXISTS `notification`;

-- ─── Table User ────────────────────────────────────────────────────────
CREATE TABLE `user` (
  `id` VARCHAR(50) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('user', 'admin', 'helpdesk') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Users
INSERT INTO `user` (`id`, `name`, `email`, `password`, `role`) VALUES
('u1', 'Faisal Mahendra', 'user@helpdesk.com', '123456', 'user'),
('a1', 'Admin Helpdesk', 'admin@helpdesk.com', '123456', 'admin'),
('h1', 'Budi Santoso', 'helpdesk@helpdesk.com', '123456', 'helpdesk'),
('h2', 'Siti Rahma', 'siti@helpdesk.com', '123456', 'helpdesk'),
('h3', 'Ahmad Wijaya', 'ahmad@helpdesk.com', '123456', 'helpdesk'),
('h4', 'Rini Kusuma', 'rini@helpdesk.com', '123456', 'helpdesk');

-- ─── Table Ticket ──────────────────────────────────────────────────────
CREATE TABLE `ticket` (
  `id` INT AUTO_INCREMENT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NOT NULL,
  `status` ENUM('open', 'assign', 'in_progress', 'close') NOT NULL DEFAULT 'open',
  `priority` ENUM('low', 'medium', 'high') NOT NULL DEFAULT 'medium',
  `created_by_id` VARCHAR(50) NOT NULL,
  `assigned_helpdesk_id` VARCHAR(50) DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`created_by_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`assigned_helpdesk_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Tickets
INSERT INTO `ticket` (`id`, `title`, `description`, `status`, `priority`, `created_by_id`, `assigned_helpdesk_id`, `created_at`, `updated_at`) VALUES
(1, 'Komputer Lab Tidak Bisa Menyala', 'Komputer di Lab A nomor 12 tidak bisa menyala sejak pagi. Sudah dicoba dinyalakan beberapa kali namun tidak ada respon sama sekali.', 'open', 'high', 'u1', NULL, '2026-04-20 09:00:00', '2026-04-20 10:30:00'),
(2, 'Koneksi WiFi Lambat di Gedung B', 'Koneksi WiFi di Gedung B lantai 2 sangat lambat sejak 3 hari lalu. Kecepatan download hanya 0.5 Mbps.', 'in_progress', 'medium', 'u1', 'h1', '2026-04-18 08:00:00', '2026-04-19 16:00:00'),
(3, 'Printer Tidak Bisa Print', 'Printer di ruang TU tidak bisa mencetak dokumen. Muncul error "Printer Offline".', 'close', 'medium', 'u1', 'h2', '2026-04-16 13:00:00', '2026-04-17 11:00:00');

-- ─── Table Ticket History ──────────────────────────────────────────────
CREATE TABLE `ticket_history` (
  `id` INT AUTO_INCREMENT NOT NULL,
  `ticket_id` INT NOT NULL,
  `action` VARCHAR(255) NOT NULL,
  `status` ENUM('open', 'assign', 'in_progress', 'close') NOT NULL,
  `actor_id` VARCHAR(50) NOT NULL,
  `actor_name` VARCHAR(100) NOT NULL,
  `actor_role` VARCHAR(50) NOT NULL,
  `changed_at` DATETIME NOT NULL,
  `note` TEXT,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed History
INSERT INTO `ticket_history` (`ticket_id`, `action`, `status`, `actor_id`, `actor_name`, `actor_role`, `changed_at`, `note`) VALUES
(1, 'Tiket dibuat', 'open', 'u1', 'Faisal Mahendra', 'User', '2026-04-20 09:00:00', 'Tiket berhasil dibuat'),
(2, 'Tiket dibuat', 'open', 'u1', 'Faisal Mahendra', 'User', '2026-04-18 08:00:00', 'Tiket berhasil dibuat'),
(2, 'Tiket diterima Admin', 'assign', 'a1', 'Admin Helpdesk', 'Admin', '2026-04-19 09:00:00', 'Tiket diterima dan diproses'),
(2, 'Assign ke Helpdesk', 'in_progress', 'a1', 'Admin Helpdesk', 'Admin', '2026-04-19 09:05:00', 'Assign ke Budi Santoso'),
(3, 'Tiket dibuat', 'open', 'u1', 'Faisal Mahendra', 'User', '2026-04-16 13:00:00', 'Tiket berhasil dibuat'),
(3, 'Tiket diterima Admin', 'assign', 'a1', 'Admin Helpdesk', 'Admin', '2026-04-16 14:00:00', 'Tiket diterima Admin'),
(3, 'Assign ke Helpdesk', 'in_progress', 'a1', 'Admin Helpdesk', 'Admin', '2026-04-16 14:05:00', 'Assign ke Siti Rahma'),
(3, 'Pekerjaan selesai', 'close', 'h2', 'Siti Rahma', 'Helpdesk', '2026-04-17 11:00:00', 'Pekerjaan selesai');

-- ─── Table Comment ─────────────────────────────────────────────────────
CREATE TABLE `comment` (
  `id` INT AUTO_INCREMENT NOT NULL,
  `ticket_id` INT NOT NULL,
  `body` TEXT NOT NULL,
  `user_name` VARCHAR(100) NOT NULL,
  `user_role` VARCHAR(50) NOT NULL DEFAULT 'user',
  `is_internal` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Comments
INSERT INTO `comment` (`ticket_id`, `body`, `user_name`, `user_role`, `is_internal`, `created_at`) VALUES
(1, 'Terima kasih laporannya. Kami akan segera cek ke lapangan.', 'Admin Helpdesk', 'admin', 0, '2026-04-20 10:30:00'),
(2, 'Sudah kami identifikasi, ada gangguan pada access point lantai 2.', 'Admin Helpdesk', 'admin', 0, '2026-04-19 14:00:00'),
(2, 'Kapan kira-kira bisa normal kembali?', 'Faisal Mahendra', 'user', 0, '2026-04-19 15:30:00'),
(2, 'Estimasi selesai besok siang, menunggu spare part.', 'Budi Santoso', 'helpdesk', 0, '2026-04-19 16:00:00'),
(3, 'Masalah sudah diselesaikan. Driver printer diinstal ulang.', 'Siti Rahma', 'helpdesk', 0, '2026-04-17 11:00:00');

-- ─── Table Notification ────────────────────────────────────────────────
CREATE TABLE `notification` (
  `id` INT AUTO_INCREMENT NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `body` TEXT NOT NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `ticket_id` INT DEFAULT NULL,
  `target_role` VARCHAR(50) DEFAULT NULL,
  `target_user_id` VARCHAR(50) DEFAULT NULL,
  `created_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Notifications
INSERT INTO `notification` (`id`, `title`, `body`, `is_read`, `ticket_id`, `target_role`, `target_user_id`, `created_at`) VALUES
(1, 'Tiket #2 Ditugaskan', 'Tiket "Koneksi WiFi Lambat di Gedung B" telah ditugaskan kepada Anda.', 0, 2, 'helpdesk', 'h1', '2026-04-19 09:05:00'),
(2, 'Tiket #2 Diproses', 'Tiket kamu sedang ditangani oleh Budi Santoso.', 0, 2, 'user', 'u1', '2026-04-19 09:05:00'),
(3, 'Tiket #3 Selesai', 'Tiket "Printer Tidak Bisa Print" telah selesai ditangani.', 1, 3, 'user', 'u1', '2026-04-17 11:00:00');

SET FOREIGN_KEY_CHECKS=1;
