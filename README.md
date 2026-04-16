# 🛒 Sistem Point of Sales (POS) - Kasir API

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white)

Selamat datang di repositori Sistem Point of Sales (POS) Kasir! Proyek ini saya bangun sebagai portofolio implementasi **Full-Stack Development**, dengan fokus utama pada pemahaman mendalam tentang **Pembangunan RESTful API menggunakan Framework Laravel**. 

Aplikasi ini memisahkan secara jelas antara backend (penyedia data utama) dan frontend (antarmuka pengguna interaktif), membentuk sistem manajemen kasir, inventaris, dan transaksi harian yang solid.

---

## 🎯 Fokus Pembelajaran Backend (Laravel API)

Struktur `backend` di dalam proyek ini difokuskan pada pengimplementasian best-practice Laravel modern untuk REST API:

1. **Authentication (Keamanan):**
   - Menggunakan **Laravel Sanctum** untuk sistem autentikasi Bearer Token (Token-based API auth).
   - Pengamanan routing dan resource access.

2. **RESTful Architecture (CRUD & Validasi):**
   - Pola interaksi API modern (`GET`, `POST`, `PUT`, `DELETE`).
   - Manajemen *Products*, *Categories*, dan *Units*. Latihan validasi input menggunakan request class.

3. **Kompleksitas Query & Rekap Data:**
   - **Transaction Handling**: Menangani logic *checkout*, pemotongan stok otomatis (event listener/observer), dan validasi keranjang belanja.
   - **Reporting (Reporting API)**: *Data Agregation* menggunakan Eloquent ORM, seperti `summery-by-cashier`, rekap pendapatan bulanan, dan *best-selling products*.
   - **Searching & Pagination**: Pembuatan fitur *search/filter* data yang responsif dikombinasikan dengan pagination otomatis untuk menangani data skala besar.

4. **Audit Logging:**
   - Endpoint khusus (Audit Controller) untuk merekam dan menyajikan jejak perilaku maupun perubahan data untuk memfasilitasi kebutuhan compliance admin.

---

## 📁 Struktur Repositori

Proyek ini menggunakan arsitektur modular sederhana dengan memisahkan *backend* dan *front-end* di dalam dua folder utama:

```text
Kasir/
├── backend/       # Inti sistem (API Server), dibangun menggunakan Laravel 12.x
└── frontend/      # UI/UX Klien aplikasi (POS App), menggunakan framework Flutter 3.x
```

### 🧰 Teknologi yang Digunakan
- **Backend API**: PHP 8.2, Laravel 12.x, MySQL.
- **Frontend App**: Dart, Flutter SDK, Riverpod (State Management), Http Client.

---

## 🚀 Endpoint API Utama (API Highlights)

Berikut adalah rekapitulasi jalur *REST API* yang dibangun di aplikasi Kasir ini:

### 🔐 Authentication
- `POST /api/login` - Otentikasi dan pembuatan token Sanctum.
- `GET  /api/user/get` - Mengembalikan data profil kasir yang sedang aktif.

### 📦 Manajemen Inventaris (Products & Categories)
- `GET  /api/product/get/paginate` - Mengambil daftar produk (beserta paginasi).
- `GET  /api/product/search` - Mesin pencarian produk *real-time*.
- `POST /api/product/insert` - Menambah produk baru ke etalase.
- `POST /api/product/update-stock` - Mengubah kuantitas item inventaris secara massal.
- `GET  /api/category/get` - Mengambil seluruh referensi kategori item.

### 💳 Transaksi dan *Checkout*
- `POST /api/transaction/insert` - Menampung proses checkout kasir, mencatat pesanan, dan mengunci stok item.
- `GET  /api/transaction/get` - Riwayat data pesanan kasir.
- `POST /api/transaction/{id}/cancel` - Memproses pembatalan keranjang/transaksi dan mengembalikan status item (Rollback action).

### 📊 Laporan dan Analitik (Dashboard & Aggregation)
- `GET /api/product/best-seller` - 10 produk dengan angka penjualan kumulatif tertinggi.
- `GET /api/transaction/get/summery` - Omset pendapatan dan ringkasan hari ini.
- `GET /api/transaction/monthly-summary` - Rekap grafik pendapatan per-bulan (Trend Analysis).

---

## 💻 Cara Menjalankan Secara Lokal (Local Setup)

Jika Anda ingin mencoba menjalankan atau membedah struktur source code proyek ini di mesin lokal, silakan ikuti petunjuk berikut:

### 1. Menjalankan Backend (Laravel API)
1. Masuk ke direktori `/backend`.
2. Salin template kredensial environment: `cp .env.example .env`.
3. Pasang library PHP: `composer install`.
4. Hasilkan key keamanan: `php artisan key:generate`.
5. Sesuaikan isian database (`DB_DATABASE`, `DB_USERNAME`, dll) pada berkas `.env`.
6. Eksekusi tabel migrasi dan data palsu (jika ada): `php artisan migrate --seed`.
7. Jalankan lokal server: `php artisan serve`.

### 2. Menjalankan Frontend (Flutter App)
1. Masuk ke direktori `/frontend`.
2. Ubah `baseUrl` / alamat server endpoint pada file konfigurasi jaringan `lib/data/` (arahkan ke `http://127.0.0.1:8000/api` atau sesuai *network* server lokal Anda).
3. Unduh *package* dart yang dibutuhkan: `flutter pub get`.
4. Jalankan aplikasi (pada emulator, web browser, atau windows app): `flutter run`.

---

> *Proyek ini saya kembangkan sebagai sarana asah *skill* dalam penerapan logika bisnis yang rapi pada Back-End (Laravel API) serta manajemen *state* (Riverpod) pada Front-End (Flutter). Saran (Issues) maupun kontribusi perbaikan kode (Pull Request) akan sangat dihargai sebagai bentuk ruang diskusi!*
