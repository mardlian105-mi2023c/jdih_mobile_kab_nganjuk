# JDIH Mobile Kabupaten Nganjuk

![Status](https://img.shields.io/badge/Status-Development-orange)
![Framework](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-FF2D20?logo=laravel&logoColor=white)

**JDIH Mobile Kabupaten Nganjuk** adalah aplikasi lintas platform (Android & iOS) yang dikembangkan menggunakan Flutter. Aplikasi ini berfungsi sebagai sarana informasi hukum digital untuk memudahkan masyarakat Kabupaten Nganjuk dalam mengakses produk hukum daerah secara cepat dan transparan.

---

## 📲 Download App (Testing Release)

Untuk keperluan pengujian (*user testing*), silakan unduh versi terbaru melalui tautan di bawah ini:

| Platform | Versi | Update Terakhir | Tautan Unduh |
| :--- | :--- | :--- | :--- |
| **Android (APK)** | v1.0.0-beta | 25 Maret 2026 | [**Download APK**](https://drive.google.com/drive/folders/1raxtRGt7PflRJQpTBSMq-URoPk4pspLL?usp=drive_link) |

> **Catatan:** Jika Anda menginstal di Android, Anda mungkin perlu mengaktifkan izin *"Install from Unknown Sources"* pada pengaturan perangkat Anda karena aplikasi ini masih dalam tahap *development/beta*.

---

## ✨ Fitur Utama

* **Pencarian Produk Hukum:** Cari Perda, Perbup, dan Keputusan Bupati dengan filter tahun dan kategori.
* **Integrasi PDF:** Membaca dokumen hukum secara langsung dengan *built-in PDF viewer*.
* **Manajemen Unduhan:** Simpan dokumen ke penyimpanan lokal untuk dibaca secara offline.
* **Notifikasi Terbaru:** Dapatkan informasi terkini mengenai produk hukum yang baru saja diterbitkan.
* **Antarmuka User-Friendly:** Desain bersih dan responsif, dioptimalkan untuk berbagai ukuran layar smartphone.

## 🛠️ Tech Stack

* **Frontend:** Flutter (Dart)
* **State Management:** Provider
* **Local Storage:** Path Provider & Shared Preferences
* **Networking:** Dio / Http (Terhubung ke REST API JDIH Nganjuk)
* **Backend:** Laravel (API Provider)
* **Tools:** Figma, Git, Docker

## 🚀 Instalasi & Jalankan

Pastikan Anda telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) di sistem Anda.

### 1. Clone Repository
```bash
git clone [https://github.com/username-anda/jdih-mobile-nganjuk.git](https://github.com/username-anda/jdih-mobile-nganjuk.git)
cd jdih-mobile-nganjuk
