# 💻 Adelmart Inventory – Aplikasi Inventaris Komputer Modern
Flutter • REST API • JSON • SharedPreferences

**Adelmart Inventory** adalah aplikasi mobile untuk mengelola inventaris komputer pada sebuah toko bernama **Adelmart**.  
Aplikasi ini dibuat menggunakan **Flutter** sebagai frontend dan **REST API** (Laravel / CodeIgniter) sebagai backend.

Fitur utama:
- Registrasi dan Login user dengan token
- Menyimpan sesi login di **SharedPreferences**
- CRUD (Create, Read, Update, Delete) data inventaris komputer
- Tampilan modern dengan tema abu-abu (grey theme)

---

## 👨‍🎓 Identitas Mahasiswa

> ⚠ Silakan sesuaikan data berikut dengan identitasmu.

| Informasi     | Detail                     |
|--------------|----------------------------|
| Nama Lengkap | _Adelia Najmi  Raissa_     |
| NIM          | _H1D023007_                |
| Shift Baru   | _Shift E_                  |
| Shift Asal   | _Shift D_                  |

---

## 📱 Demo Aplikasi

Berikut demonstrasi singkat fitur utama aplikasi: Login, Registrasi, Tambah Inventaris, Edit, Hapus, dan Logout.

- 🎬 **Link Video Demo**: ![Responsi 2 Mobile Paket 1 (H1D023007)](https://github.com/user-attachments/assets/fc7cffce-4990-4ad2-a3a1-f2534c4b2376)


pada video demo menampilkan:
1. Proses registrasi user baru
2. Proses login
3. Tampilan Home (daftar inventaris)
4. Tambah data barang
5. Edit & hapus data barang
6. Logout dan uji login ulang jika perlu

---

## 🧱 Teknologi yang Digunakan

- **Flutter** (UI & logic client)
- **Dart**
- **REST API** (Laravel / CodeIgniter – JSON)
- **HTTP Package** (`package:http/http.dart`)
- **SharedPreferences** untuk menyimpan token & informasi user
- **intl** untuk format tanggal (di `InventoryFormPage`)

---

## 📂 Struktur Proyek Flutter

Struktur folder inti aplikasi:

```text
lib/
├── models/
│   ├── app_user.dart             # Model data user hasil login (id, name, email, token)
│   └── inventory.dart            # Model data inventaris komputer
├── services/
│   └── api_service.dart          # Service pemanggilan REST API (Auth + CRUD Inventaris)
├── pages/
│   ├── login_page.dart           # Halaman Login
│   ├── register_page.dart        # Halaman Registrasi
│   ├── home_page.dart            # Halaman utama (list inventaris + aksi CRUD)
│   └── inventory_form_page.dart  # Form tambah/edit data inventaris
└── main.dart                     # Titik masuk aplikasi & pengecekan sesi login
