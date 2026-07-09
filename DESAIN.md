# UI.md
# UI/UX Design Guide - E-Ticketing Helpdesk (UAS)

## Objective

Redesign aplikasi E-Ticketing Helpdesk agar terlihat modern, profesional, clean, dan berbeda dari project Flutter praktikum lainnya.

Target:
- Tidak terlihat seperti template Flutter bawaan.
- Siap dipresentasikan saat responsi.
- Nyaman digunakan.
- Material Design 3.
- Responsive.
- Minimalis tetapi premium.

---

# Design Concept

Gunakan konsep

> Enterprise Helpdesk Dashboard + Modern SaaS

Inspirasi

- Linear
- Notion
- Jira
- Zendesk
- ClickUp
- Atlassian

Bukan seperti

❌ Flutter Counter

❌ AdminLTE

❌ Dashboard Bootstrap

❌ Template bawaan Flutter

---

# Color Palette

Primary

#2563EB

Secondary

#3B82F6

Success

#16A34A

Warning

#F59E0B

Danger

#DC2626

Background

#F8FAFC

Card

#FFFFFF

Text

#0F172A

Subtitle

#64748B

Border

#E2E8F0

---

# Font

Google Fonts

Poppins

atau

Inter

Hierarchy

Title

28
Bold

Section

20
SemiBold

Card Title

18
SemiBold

Body

15

Caption

13

---

# Border Radius

Button

16

Card

20

Dialog

24

Input

18

Bottom Sheet

28

---

# Elevation

Gunakan shadow tipis

Jangan terlalu gelap.

---

# Icon

Gunakan

Icons Rounded

atau

Cupertino Icons

Jangan memakai icon default lama.

---

# Navigation

Bottom Navigation

4 Menu

User

Dashboard

Tickets

Notification

Profile

Admin

Dashboard

Tickets

Users

Profile

Helpdesk

Dashboard

Assigned

Notification

Profile

---

# Dashboard

Jangan memakai card kotak biasa.

Gunakan

Welcome Header

Halo,
Faisal

Good Morning ☀️

---

Quick Statistic

Gunakan horizontal cards

┌─────────────┐

Open

12

└─────────────┘

┌─────────────┐

Assign

4

└─────────────┘

┌─────────────┐

Progress

6

└─────────────┘

┌─────────────┐

Close

18

└─────────────┘

Card memiliki

- icon besar
- warna berbeda
- shadow tipis

---

Recent Ticket

Card besar

Priority Badge

Status Badge

Tanggal

Assigned Helpdesk

Arrow >

---

Floating Action Button

Lingkaran besar

+

Create Ticket

---

Ticket List

Jangan ListTile default.

Gunakan Card

┌───────────────────────────────┐

🖥 Printer Tidak Bisa Digunakan

HIGH

OPEN

IT-2031

2 menit lalu

────────────────────────

John Doe

>

└───────────────────────────────┘

---

Priority Badge

High

Merah

Medium

Orange

Low

Hijau

---

Status Badge

OPEN

Blue

ASSIGN

Purple

IN PROGRESS

Orange

CLOSE

Green

Semua badge berbentuk capsule.

---

Ticket Detail

Header

Judul

Status Badge

Priority Badge

Divider

Description

Divider

Assigned Helpdesk

Divider

Lampiran

Divider

Komentar

Divider

Tracking Button

---

Tracking Screen

Gunakan Timeline

●

OPEN

09.10

User membuat tiket

│

●

ASSIGN

09.13

Admin menerima

│

●

IN PROGRESS

09.15

Assign ke Budi

│

●

CLOSE

10.20

Diselesaikan

Timeline memiliki garis vertikal.

---

Assign Dialog

Gunakan Bottom Sheet

Bukan AlertDialog.

Header

Assign Helpdesk

Search Helpdesk

Card Helpdesk

Avatar

Nama

Divisi

Button

Assign

---

Helpdesk Dashboard

Header

Hello,

Budi

Today's Assigned

Card besar

Today's Finished

Card besar

Progress Ring

Recent Assigned Ticket

---

Finish Button

Hijau

Lebar penuh

Rounded

Icon Check Circle

Text

Finish Ticket

---

Notification

Card

Icon

Judul

Deskripsi

Jam

Unread memiliki garis biru kiri.

---

Profile

Avatar besar

Nama

Role

Email

Divider

Menu

Edit Profile

Statistics

Settings

Logout

---

Login

Background

Gradient

Logo

Judul

Welcome Back

Subtitle

Sign in to continue

Input modern

Icon

Rounded

Button biru besar

Sign In

Card putih

Shadow

---

Create Ticket

Gunakan Step Form

Step 1

Informasi

Step 2

Prioritas

Step 3

Lampiran

Step 4

Review

Submit

---

Search

Gunakan Search Bar

Rounded

Shadow tipis

Placeholder

Search ticket...

---

Empty State

Gunakan ilustrasi

Tidak ada tiket

Create your first ticket.

Button

Create Ticket

---

Loading

Skeleton Loading

Jangan CircularProgressIndicator saja.

---

Animation

Gunakan

AnimatedContainer

AnimatedSwitcher

Hero Animation

Fade Transition

Slide Transition

---

Dark Mode

Support

Light

Dark

---

Responsive

Support

Android Phone

Tablet

Browser

---

Consistency

Semua Screen wajib

- Padding 20
- Radius sama
- Badge sama
- Font sama
- Warna sama
- Icon sama

---

UI Rules

JANGAN gunakan:

❌ Card kotak default

❌ ListTile polos

❌ AlertDialog bawaan

❌ Dropdown default

❌ Warna terlalu banyak

❌ Text kecil

❌ Padding tidak konsisten

❌ Shadow berlebihan

---

UX Rules

Semua aksi penting harus memiliki feedback.

Create Ticket

→ Snackbar

Assign

→ Snackbar

Finish

→ Dialog Success

Delete

→ Confirmation Dialog

Logout

→ Confirmation Dialog

---

Final Goal

UI harus terlihat seperti aplikasi enterprise modern, bukan project tugas kuliah biasa.

Ketika dosen melihat aplikasi, kesan pertama yang muncul adalah:

- Profesional
- Rapi
- Konsisten
- Modern
- Mudah digunakan
- Layak menjadi aplikasi production
- Berbeda dari mayoritas proyek Flutter praktikum.