# 💻 Adelmart Inventory – Aplikasi Inventaris Komputer Modern
• Flutter 
• REST API 
• JSON 
• SharedPreferences

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

🔌 Spesifikasi API & Database (REST API)

Backend aplikasi ini menggunakan **REST API** berbasis **Laravel / CodeIgniter** dengan database **MySQL**. API berkomunikasi dengan aplikasi Flutter menggunakan format **JSON**.

### Tabel Utama: inventories
Tabel ini digunakan untuk menyimpan seluruh data inventaris komputer di Adelmart.

| Nama Kolom    | Tipe Data | Keterangan                                           |
|---------------|-----------|------------------------------------------------------|
| id            | INT       | Primary Key, Auto Increment. ID unik tiap barang.   |
| nama          | VARCHAR   | Nama lengkap barang (misal: PC Kasir, Monitor, dll).|
| harga         | INT       | Harga barang dalam satuan Rupiah.                   |
| jumlah        | INT       | Jumlah stok barang yang tersedia.                   |
| tanggal_masuk | DATE      | Tanggal barang masuk/didata (format: yyyy-MM-dd).   |

### Tabel Pengguna (opsional, jika ada): users
Digunakan untuk autentikasi user aplikasi (login & registrasi).

| Nama Kolom | Tipe Data | Keterangan                          |
|------------|-----------|-------------------------------------|
| id         | INT       | Primary Key, Auto Increment.        |
| name       | VARCHAR   | Nama lengkap pengguna.              |
| email      | VARCHAR   | Email unik untuk login.             |
| password   | VARCHAR   | Password yang sudah di-hash.        |
| created_at | TIMESTAMP | Tanggal dibuat.                     |
| updated_at | TIMESTAMP | Tanggal diubah.                     |

### Fitur Backend

- **Authentication**  
  Menggunakan skema **Email & Password**. Endpoint `/login` akan mengembalikan **token** yang digunakan pada header `Authorization: Bearer {token}` untuk mengakses endpoint inventaris.

- **Proteksi Endpoint**  
  Endpoint `/inventories` dan variannya (`POST`, `PUT`, `DELETE`) hanya bisa diakses oleh user yang sudah login (token valid).

- **Validasi Data**  
  Server melakukan pengecekan input seperti:
  - `nama` wajib diisi
  - `harga` dan `jumlah` harus berupa angka
  - `tanggal_masuk` harus sesuai format tanggal valid

---

📝 Penjelasan Kode & Fungsi Utama

Berikut adalah breakdown logika kode untuk modul-modul penting dalam aplikasi **Adelmart Inventory**:

---

### 1. Manajemen Data Inventaris (ApiService)

📍 Lokasi: `lib/services/api_service.dart`  

Kelas `ApiService` adalah jembatan antara aplikasi Flutter dan REST API backend.

- **`register(String name, String email, String password)`**  
  Fungsi:
  - Mengirim request `POST` ke endpoint `/register`.
  - Mengirim body JSON berisi `name`, `email`, dan `password`.
  - Jika response `status != true` atau `statusCode != 200`, fungsi akan melempar `Exception` yang kemudian ditangani di UI (SnackBar).

- **`login(String email, String password)`**  
  Fungsi:
  - Mengirim request `POST` ke `/login`.
  - Menerima response berupa `token` dan data `user`.
  - Memparsing response menjadi objek `AppUser` melalui `AppUser.fromLoginJson`.
  - Jika gagal (status atau statusCode tidak sesuai), akan melempar `Exception('Login gagal')`.

- **`_headersWithToken(String token)`**  
  Fungsi:
  - Menyusun header standar untuk endpoint yang butuh autentikasi:
    - `Content-Type: application/json`
    - `Accept: application/json`
    - `Authorization: Bearer {token}`

- **`getInventories(String token)`**  
  Fungsi:
  - Mengambil data inventaris dari endpoint `GET /inventories`.
  - Response JSON bagian `data` diubah menjadi `List<Inventory>` menggunakan `Inventory.fromJson`.
  - Jika status tidak sukses → melempar exception.

- **`createInventory(String token, Inventory inv)`**  
  Fungsi:
  - Mengirim request `POST /inventories` dengan body `inv.toJson()`.
  - Digunakan saat user menambah data barang baru.

- **`updateInventory(String token, Inventory inv)`**  
  Fungsi:
  - Mengirim request `PUT /inventories/{id}`.
  - Body berisi data terbaru dari barang.
  - Digunakan saat user mengedit data inventaris.

- **`deleteInventory(String token, int id)`**  
  Fungsi:
  - Mengirim request `DELETE /inventories/{id}`.
  - Digunakan saat user menghapus data inventaris dari aplikasi.

---

### 2. Model Data Inventory & User

#### a) Model Inventory

📍 Lokasi: `lib/models/inventory.dart`

Fungsi utama:
- Menyediakan representasi data inventaris dalam bentuk objek Dart.
- Menyediakan konversi **JSON ➝ Object** (`fromJson`) dan **Object ➝ JSON** (`toJson`).

**`fromJson(Map<String, dynamic> json)`**  
- Menerima data dari API:
  - `id`
  - `nama`
  - `harga`
  - `jumlah`
  - `tanggal_masuk`
- Mengubahnya menjadi object `Inventory`.
- Ada penanganan khusus untuk `harga` dan `jumlah` supaya aman kalau API kadang mengirim string atau int.

**`toJson()`**  
- Dipakai saat mengirim data ke server untuk **tambah** atau **edit**:
  - Menghasilkan struktur JSON:
    ```json
    {
      "nama": "...",
      "harga": 0,
      "jumlah": 0,
      "tanggal_masuk": "yyyy-MM-dd"
    }
    ```

#### b) Model AppUser

📍 Lokasi: `lib/models/app_user.dart`

- Menyimpan data user yang sudah login:
  - `id`
  - `name`
  - `email`
  - `token`
- **`fromLoginJson(Map<String, dynamic> json)`**:
  - Mengambil data dari response `/login`:
    - `json['data']['user']['id']`
    - `json['data']['user']['name']`
    - `json['data']['user']['email']`
    - `json['data']['token']`
  - Digunakan setelah login berhasil untuk menyusun object user.

---

### 3. Halaman Utama & CRUD (HomePage)

📍 Lokasi: `lib/pages/home_page.dart`

`HomePage` adalah dashboard utama yang menampilkan daftar inventaris komputer Adelmart.

- **`_loadData()`**  
  Fungsi:
  - Memanggil `ApiService.getInventories(widget.user.token)`.
  - Mengisi `_items` dengan `List<Inventory>` dari API.
  - Mengatur `_loading` untuk menampilkan indikator loading ketika data sedang diambil.

- **`_addItem()`**  
  Fungsi:
  - Menavigasi ke `InventoryFormPage` (mode tambah).
  - Menerima `Inventory?` dari `Navigator.pop`.
  - Jika tidak null → dikirim ke API menggunakan `createInventory`.
  - Setelah sukses → memanggil `_loadData()` untuk refresh list.

- **`_editItem(Inventory item)`**  
  Fungsi:
  - Menavigasi ke `InventoryFormPage` dengan `inventory: item` (mode edit).
  - Menerima data hasil edit dari form.
  - Mengirim perubahan ke API dengan `updateInventory`.
  - Reload data setelah update.

- **`_deleteItem(Inventory item)`**  
  Fungsi:
  - Menampilkan dialog konfirmasi `AlertDialog`.
  - Jika user menekan “HAPUS” → memanggil `ApiService.deleteInventory`.
  - Setelah berhasil → memanggil `_loadData()` lagi.

- **`_logout()`**  
  Fungsi:
  - Menghapus semua data di `SharedPreferences` (token, name, email).
  - Mengarahkan user kembali ke `LoginPage`.

---

### 4. Form Tambah & Edit Barang (InventoryFormPage)

📍 Lokasi: `lib/pages/inventory_form_page.dart`

Halaman ini menangani input data inventaris, baik untuk **tambah** maupun **edit**.

- **`initState()`**  
  Logika:
  - Jika `widget.inventory != null` → mode edit:
    - Mengisi field `nama`, `harga`, `jumlah`, `tanggal_masuk` dengan data lama.
  - Jika `null` → mode tambah:
    - Mengisi `tanggal_masuk` otomatis dengan tanggal hari ini (`DateTime.now()`).

- **`_pickDate()`**  
  Fungsi:
  - Menampilkan `showDatePicker`.
  - Hasil tanggal diformat menjadi `yyyy-MM-dd`.
  - Di-set ke textfield tanggal.

- **`_submit()`**  
  Fungsi:
  - Validasi form.
  - Membuat object `Inventory` dari input textfield.
  - Mengembalikan object tersebut menggunakan `Navigator.pop(context, inv)` ke `HomePage`.
  - Di `HomePage`, object ini diputuskan akan dipakai untuk `createInventory` (tambah) atau `updateInventory` (edit).

---

### 5. Helper Sesi & Autentikasi (Login & Main)

📍 Lokasi:
- `lib/pages/login_page.dart`
- `lib/pages/register_page.dart`
- `lib/main.dart`

#### a) `login_page.dart`

- Fungsi utama: `_doLogin()`
  - Validasi form.
  - Panggil `ApiService.login`.
  - Simpan `token`, `name`, dan `email` ke `SharedPreferences`.
  - Navigasi ke `HomePage`.

#### b) `register_page.dart`

- Fungsi utama: `_doRegister()`
  - Validasi input nama, email, password.
  - Panggil `ApiService.register`.
  - Jika sukses → tampilkan pesan dan kembali ke `LoginPage`.

#### c) `main.dart`

- Fungsi utama: `_checkLogin()`
  - Mengecek apakah `SharedPreferences` masih menyimpan `token`, `name`, dan `email`.
  - Jika ada → langsung buat object `AppUser` dan arahkan ke `HomePage`.
  - Jika tidak ada → arahkan ke `LoginPage`.
- Membantu user **tidak perlu login ulang** selama sesi masih tersimpan.

---
