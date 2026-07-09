# SKILL.md
# Final Project UAS - Mobile Apps Praktikum
## E-Ticketing Helpdesk

## Tujuan
Menyelesaikan seluruh revisi aplikasi E-Ticketing Helpdesk sesuai arahan dosen agar memenuhi syarat responsi dan pengumpulan UAS.

Referensi kebutuhan sistem mengacu pada dokumen Software Requirement Specification (SRS) E-Ticketing Helpdesk versi 2.0.0. 0

---

# TARGET PENGUMPULAN

Laporan Akhir
- Format PDF

Repository GitHub/GitLab

Repository Flutter
Berisi:
- Source Code Flutter
- APK Release
- Export Database

Repository Backend
- Laravel / Golang / Node / Backend lain yang digunakan

Jika menggunakan Golang:
- Source code Golang WAJIB berada pada repository terpisah.

Total:
- 2 Link Repository

---

# OUTPUT YANG HARUS DIHASILKAN

## Repository Flutter

Harus berisi:

```
flutter_project/
│
├── lib/
├── assets/
├── android/
├── ios/
├── apk/
│      app-release.apk
│
├── database/
│      helpdesk.sql
│
├── README.md
└── SKILL.md
```

---

## Repository Backend

Harus berisi

```
backend/
│
├── app/
├── routes/
├── database/
├── public/
├── README.md
```

---

# APK

Build release

```
flutter build apk --release
```

Hasil

```
build/app/outputs/flutter-apk/app-release.apk
```

Salin ke folder

```
apk/app-release.apk
```

---

# DATABASE

Export database menjadi

```
helpdesk.sql
```

Masukkan ke folder

```
database/
```

---

# PERUBAHAN FLOW TIKET (WAJIB)

Hilangkan tombol ubah Status secara manual.

Status harus berubah otomatis sesuai aktivitas pengguna.

---

## Flow Ticket Terbaru

### 1. User

Saat membuat tiket

```
Create Ticket
```

Status otomatis

```
OPEN
```

Tidak boleh memilih status.

---

### 2. Admin

Admin menerima tiket.

Admin melakukan Assign Helpdesk.

Saat tombol Assign ditekan

Status otomatis berubah menjadi

```
ASSIGN
```

Setelah Helpdesk dipilih

Status otomatis berubah menjadi

```
IN PROGRESS
```

Tidak boleh ada dropdown status.

---

### 3. Helpdesk

Helpdesk melihat tiket yang ditugaskan.

Status tetap

```
IN PROGRESS
```

Helpdesk mengerjakan tiket.

Tidak boleh mengubah status secara manual.

---

### 4. Finish

Ketika pekerjaan selesai

Helpdesk klik

```
Finish
```

Status otomatis menjadi

```
CLOSE
```

---

# FLOW STATUS FINAL

```
User
 │
 ▼
OPEN
 │
 │ Admin Assign
 ▼
ASSIGN
 │
 │ Pilih Helpdesk
 ▼
IN PROGRESS
 │
 │ Helpdesk Finish
 ▼
CLOSE
```

---

# RULE STATUS

User
- otomatis OPEN

Admin Assign
- otomatis ASSIGN

Helpdesk dipilih
- otomatis IN PROGRESS

Helpdesk Finish
- otomatis CLOSE

Tidak ada tombol:

- Change Status
- Dropdown Status
- Edit Status Manual

Status hanya berubah berdasarkan aksi sistem.

---

# Dashboard

Pastikan dashboard menampilkan

- Total Ticket
- Open
- Assign
- In Progress
- Close

sesuai SRS. 1

---

# Tracking Ticket

Tracking harus menampilkan histori

OPEN

↓

ASSIGN

↓

IN PROGRESS

↓

CLOSE

Beserta

- tanggal
- waktu
- pengguna
- aktivitas

---

# Mobile Responsi Checklist

Sebelum responsi

Pastikan dapat

✅ Login

✅ Register

✅ Dashboard

✅ List Ticket

✅ Detail Ticket

✅ Create Ticket

✅ Assign Ticket

✅ Finish Ticket

✅ Tracking

✅ Statistik

✅ Logout

---

# Saat Responsi

Siapkan

## 1

Jalankan aplikasi

boleh menggunakan

- Device
- Emulator
- Browser

---

## 2

Buka database

Tunjukkan

- tabel user
- tabel ticket
- tabel history
- tabel assignment

---

## 3

Demokan Flow

User Login

↓

Create Ticket

↓

Status OPEN

↓

Admin Login

↓

Assign Ticket

↓

Status ASSIGN

↓

Pilih Helpdesk

↓

Status IN PROGRESS

↓

Helpdesk Login

↓

Kerjakan Ticket

↓

Klik Finish

↓

Status CLOSE

↓

Tracking berhasil

---

# Testing Checklist

## User

- Login
- Register
- Create Ticket
- Upload File
- View Ticket
- Tracking
- Notification

---

## Admin

- Login
- View Ticket
- Assign Helpdesk
- Dashboard
- Manage User

---

## Helpdesk

- Login
- View Assigned Ticket
- Reply Ticket
- Finish Ticket

---

# README Repository

Minimal berisi

- Deskripsi Project
- Cara Install
- Konfigurasi Backend
- Import Database
- Build APK
- Screenshot
- Anggota Kelompok
- Link Backend Repository
- Link Flutter Repository

---

# Checklist Sebelum Submit

## Laporan

- [ ] PDF Final

## Flutter

- [ ] Source Code
- [ ] APK
- [ ] README
- [ ] SKILL.md

## Backend

- [ ] Source Code
- [ ] README

## Database

- [ ] helpdesk.sql

## GitHub

- [ ] Link Flutter
- [ ] Link Backend

## Aplikasi

- [ ] Build Success
- [ ] Tidak Error
- [ ] Semua Flow Berjalan
- [ ] Status Otomatis
- [ ] Tracking Berjalan
- [ ] Dashboard Sesuai

---

# Goal Akhir

Aplikasi memenuhi seluruh Functional Requirement utama sesuai SRS dan revisi dosen:

- User membuat tiket → status OPEN.
- Admin melakukan assign → status ASSIGN.
- Setelah helpdesk dipilih → status IN PROGRESS.
- Helpdesk menyelesaikan pekerjaan → status CLOSE.
- Perubahan status dilakukan otomatis oleh sistem tanpa tombol ubah status manual.
- APK, source code, export database, laporan PDF, dan dua repository GitHub siap dikumpulkan.