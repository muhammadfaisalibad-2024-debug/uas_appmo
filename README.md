# E-Ticketing Helpdesk Mobile Application 📱

Aplikasi mobile E-Ticketing Helpdesk untuk UAS Mobile Apps Praktikum. Aplikasi ini mengelola pelaporan masalah IT secara terstruktur dengan alur perubahan status tiket yang otomatis dan terintegrasi.

---

## 👥 Anggota Kelompok
- **Muhammad Faisal Ibad** ( NIM / NIM Anggota Lain )

---

## 🌟 Fitur Utama
1. **Multi-Role Authentication**: 
   - **User**: Membuat tiket baru, mengirim balasan komentar, dan memantau status tiket.
   - **Admin**: Mengelola seluruh tiket masuk dan menugaskan tiket ke Helpdesk tertentu.
   - **Helpdesk**: Menyelesaikan pekerjaan tiket yang ditugaskan, membalas komentar, dan memperbarui penyelesaian masalah.
2. **Alur Status Otomatis (Automatic State Flow)**:
   - Status diubah secara otomatis oleh sistem berdasarkan aksi pengguna tanpa tombol ubah status manual.
   - Alur: `User membuat tiket` (OPEN) ➔ `Admin menugaskan` (ASSIGN) ➔ `Helpdesk terpilih` (IN PROGRESS) ➔ `Helpdesk mengklik Finish` (CLOSE).
3. **Tracking & Timeline Histori**:
   - Histori pelacakan tiket lengkap dengan waktu, tanggal, aktor, peran, dan catatan aktivitas secara visual (timeline).
4. **Statistik & Visualisasi**:
   - Diagram distribusi status tiket dan tingkat prioritas (High, Medium, Low) menggunakan representasi visual linear.
5. **Role-Based Notifications**:
   - Pemberitahuan khusus peran (misal: Helpdesk mendapat notifikasi saat ditugaskan tiket, User saat status berubah).

---

## 🛠️ Panduan Instalasi & Jalankan Aplikasi

### Prasyarat (Prerequisites)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.0.0 atau lebih baru)
- Android Studio / VS Code dengan plugin Flutter terpasang.
- Emulator Android atau perangkat fisik dengan USB Debugging aktif.

### Langkah-Langkah Menjalankan
1. Clone repository ini:
   ```bash
   git clone <link_flutter_repository>
   cd uts_appmobile
   ```
2. Jalankan perintah get packages:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi di emulator/perangkat target:
   ```bash
   flutter run
   ```

---

## 📦 Build APK Release
Untuk menghasilkan file APK rilis mandiri, jalankan perintah berikut:
```bash
flutter build apk --release
```
Hasil build APK akan tersimpan di:
```
build/app/outputs/flutter-apk/app-release.apk
```
Salin file tersebut ke folder root proyek di:
```
apk/app-release.apk
```

---

## 🗄️ Import Database & Konfigurasi Backend
Database skema SQL tersedia di dalam folder database proyek ini:
```
database/helpdesk.sql
```

### Langkah Import Database (MySQL/MariaDB)
1. Buat database baru bernama `helpdesk`:
   ```sql
   CREATE DATABASE helpdesk;
   ```
2. Import file `database/helpdesk.sql` ke database:
   ```bash
   mysql -u root -p helpdesk < database/helpdesk.sql
   ```

### Konfigurasi Backend
- Source code backend berada pada repository terpisah.
- **Link Backend Repository**: [https://github.com/muhammadfaisalibad/helpdesk-backend](https://github.com/muhammadfaisalibad/helpdesk-backend)
- **Link Flutter Repository**: [https://github.com/muhammadfaisalibad/uts_appmobile](https://github.com/muhammadfaisalibad/uts_appmobile)

---

## 📸 Dokumentasi & Screenshot

Berikut adalah cuplikan antarmuka aplikasi E-Ticketing Helpdesk:

### 1. Login & Register
*Halaman Login mendukung navigasi cerdas berbasis akun demo.*
- **User**: `user@helpdesk.com` | Password: `123456`
- **Admin**: `admin@helpdesk.com` | Password: `123456`
- **Helpdesk**: `helpdesk@helpdesk.com` | Password: `123456`

### 2. Dashboard User
*Menampilkan statistik tiket personal, tombol buat tiket, dan daftar tiket terbaru.*

### 3. Dashboard Admin
*Menampilkan ringkasan seluruh tiket masuk dan metrik status kerja.*

### 4. Dashboard Helpdesk
*Menampilkan daftar tiket yang ditugaskan khusus untuk helpdesk yang bersangkutan.*

### 5. Buat Tiket
*User membuat tiket baru dengan prioritas yang diinginkan, status otomatis diset ke **OPEN**.*

### 6. Assign Helpdesk (Admin)
*Proses terintegrasi: Admin menugaskan staff helpdesk, secara otomatis mengubah status tiket menjadi **ASSIGN** lalu **IN PROGRESS**.*

### 7. Tracking Ticket
*Menampilkan visualisasi timeline dan histori perubahan status tiket secara real-time.*

### 8. Finish Ticket (Helpdesk)
*Helpdesk mengklik tombol "Selesaikan Tiket" untuk menandai pekerjaan selesai, status otomatis diset ke **CLOSE**.*

### 9. Statistik Tiket
*Menampilkan grafik sebaran status tiket dan prioritas kerja.*

---
*Proyek ini disusun untuk memenuhi syarat responsi ujian akhir praktikum pemrograman mobile.*
