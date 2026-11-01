# bootstrap-cv-inflation-analysis

# Perbandingan Koefisien Variasi Inflasi Bulanan Antara DKI Jakarta dan Gabungan 7 Kota Menggunakan Metode Bootstrap

Repositori ini berisi kode dan dokumentasi analisis statistik untuk membandingkan fluktuasi inflasi bulanan antara **DKI Jakarta** dan **Gabungan 7 Kota** (Bogor, Sukabumi, Bandung, Cirebon, Bekasi, Depok, dan Tasikmalaya) selama tahun 2023. Penelitian ini menggunakan ukuran **Koefisien Variasi (CV)** yang diuji signifikansinya menggunakan pendekatan **Nonparametric Bootstrap**.

---

## Latar Belakang & Tujuan
DKI Jakarta sering kali dijadikan indikator acuan utama perekonomian nasional. Namun, wilayah penyangga dan kawasan urban di sekitarnya (Gabungan 7 Kota di Jawa Barat) memiliki dinamika sosial-ekonomi yang unik. 
* **Tujuan Penelitian:**
  1. Membandingkan fluktuasi inflasi bulanan antara DKI Jakarta dan Gabungan 7 Kota menggunakan Koefisien Variasi (CV).
  2. Menguji kesamaan nilai Koefisien Variasi menggunakan uji *bootstrap* nonparametrik.
  3. Melakukan studi simulasi untuk menilai sensitivitas metode *bootstrap* terhadap variasi parameter dan ukuran sampel ($n$).

---

## Ringkasan Hasil Utama
* **Data Aktual (Inflasi 2023):**
  * **DKI Jakarta:** Rata-rata inflasi $\approx 0.19\%$, Standar Deviasi $\approx 0.18$, Koefisien Variasi (CV) $\approx 0.51$ (atau $0.93$ tergantung formula basis).
  * **Gabungan 7 Kota:** Rata-rata inflasi $\approx 0.20\%$, Standar Deviasi $\approx 0.19$, Koefisien Variasi (CV) $\approx 0.59$ (atau $0.96$).
* **Hasil Uji Bootstrap:** 
  * Diperoleh nilai **$p\text{-value} = 0.95$**. Karena $p\text{-value} > \alpha$ (0.05), maka **gagal menolak $H_0$**. Artinya, tidak terdapat perbedaan yang signifikan secara statistik antara fluktuasi/variasi relatif inflasi bulanan di DKI Jakarta dan Gabungan 7 Kota.
* **Studi Simulasi:** 
  * Simulasi membuktikan bahwa metode *bootstrap* semakin sensitif dan akurat dalam mendeteksi perbedaan CV ketika ukuran sampel semakin besar dan perbedaan standar deviasi antar populasi semakin mencolok.

---

## Struktur & Isi Proyek
* **`Inflasi 90 Kota (Umum), 2023.xlsx`**: Dataset pendukung dari Badan Pusat Statistik (BPS) terkait IHK dan inflasi bulanan.
* **`Perbandingan Koefisien Variasi Inflasi Bulanan Antara DKI Jakarta dan Gabungan 7 Kota Menggunakan Metode Bootstrap.R`**: Berisi seluruh skrip R lengkap mencakup:
  * Perhitungan statistik deskriptif & pengecekan *outlier* (aturan IQR).
  * Visualisasi data (Boxplot, Histogram, dan Grafik Garis Perbandingan).
  * Implementasi algoritma *Bootstrap* nonparametrik untuk komparasi CV.
  * Skrip simulasi monte carlo / pembangkitan data normal untuk uji sensitivitas sampel.
* **`Bootstrap.pdf` / Dokumen Penelitian**: Manuskrip/laporan lengkap dari riset ini.
