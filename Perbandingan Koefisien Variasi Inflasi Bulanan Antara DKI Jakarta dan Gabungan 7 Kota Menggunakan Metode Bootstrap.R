# Data Gabungan 7 Kota
bulan <- c("Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des")
inflasi_gabungan <- c(0.47, 0.35, -0.18, 0.4, 0.12, 0.15, 0.21, -0.05, 0.11, 0.13, 0.36, 0.37)
ihk_gabungan <- c(115.65, 116.06, 115.85, 116.31, 116.45, 116.63, 116.88, 116.82, 116.95, 117.1, 117.52, 117.96)

# Data DKI Jakarta
inflasi_jakarta <- c(0.09, 0.19, 0.36, 0.4, -0.1, 0.01, 0.19, 0.01, 0.19, 0.13, 0.3, 0.5)
ihk_jakarta <- c(112.21, 112.42, 112.83, 113.28, 113.17, 113.18, 113.39, 113.4, 113.61, 113.76, 114.1, 114.67)

library(e1071)

desc_stats <- function(x) {
  c(
    Min = min(x),
    Q1 = quantile(x, 0.25),
    Median = median(x),
    Mean = mean(x),
    Q3 = quantile(x, 0.75),
    Max = max(x),
    SD = sd(x),
    Skewness = skewness(x),
    Kurtosis = kurtosis(x)
  )
}

data.frame(
  DKI_Jakarta = desc_stats(inflasi_jakarta),
  Gabungan_7_Kota = desc_stats(inflasi_gabungan)
)

# Boxplot
boxplot(inflasi_jakarta, inflasi_gabungan,
        names = c("DKI Jakarta", "Gabungan 7 Kota"),
        main = "Boxplot Inflasi Bulanan",
        ylab = "Inflasi (%)")

# Outlier dengan IQR Rule
outlier_iqr <- function(x) {
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQR <- Q3 - Q1
  x[x < Q1 - 1.5 * IQR | x > Q3 + 1.5 * IQR]
}

cat("Outlier Gabungan 7 Kota:\n"); print(outlier_iqr(inflasi_gabungan))
cat("Outlier DKI Jakarta:\n"); print(outlier_iqr(inflasi_jakarta))

par(mfrow = c(2, 1))
hist(inflasi_gabungan, main = "Histogram Inflasi Bulanan Gabungan 7 Kota", xlab = "Inflasi (%)")
hist(inflasi_jakarta, main = "Histogram Inflasi Bulanan DKI Jakarta", xlab = "Inflasi (%)")

# Grafik garis Inflasi
# 1. Set margin kanan cukup agar legend muat
par(mfrow = c(1, 1))        # kembali ke layout 1 grafik
par(mar = c(5, 4, 4, 7))    # atur margin kanan agar legend muat

# 2. Plot inflasi Gabungan 7 Kota
plot(inflasi_gabungan, type = "o", col = "blue",
     ylim = range(c(inflasi_gabungan, inflasi_jakarta)),
     xaxt = "n", xlab = "Bulan", ylab = "Inflasi (%)",
     main = "Grafik Inflasi Bulanan")

# 3. Tambahkan garis inflasi DKI Jakarta
lines(inflasi_jakarta, type = "o", col = "red")

# 4. Label bulan di sumbu x
axis(1, at = 1:12, labels = bulan)

# 5. Legend kecil, posisi rapi & gak kepotong
legend("topright",
       inset = c(-0.465, 0),   # geser sedikit keluar ke kanan
       legend = c("Gabungan 7 Kota", "DKI Jakarta"),
       col = c("blue", "red"),
       lty = 1,
       pch = 1,
       cex = 0.6,            # ukuran kecil
       xpd = TRUE)          # biar bisa keluar area plot

# Fungsi untuk menghitung Koefisien Variasi (CV)
cv <- function(x) {
  sd(x) / mean(x)
}

# Menghitung CV untuk inflasi Jakarta dan 7 Kota
cv_jakarta <- cv(inflasi_jakarta)
cv_jakarta 
cv_gabungan <- cv(inflasi_gabungan)
cv_gabungan
T_obs <- abs(cv_jakarta - cv_gabungan)
T_obs

# Bootstrap untuk pengujian perbedaan CV
set.seed(123)  # Untuk reproduktifitas hasil
B <- 10000  # Jumlah replikasi bootstrap
n1 <- length(inflasi_jakarta)
n1
n2 <- length(inflasi_gabungan)
n2
combined <- c(inflasi_jakarta, inflasi_gabungan)
combined

# Simpan hasil bootstrap
T_boot <- numeric(B)
for (b in 1:B) {
  resample <- sample(combined, size = n1 + n2, replace = TRUE)
  sample1 <- sample(resample, n1, replace = TRUE)
  sample2 <- sample(resample, n2, replace = TRUE)
  
  cv1 <- cv(sample1)
  cv2 <- cv(sample2)
  
  T_boot[b] <- abs(cv1 - cv2)
}
cv1
cv2

# Hitung p-value
p_value <- mean(T_boot >= T_obs)
cat("T asli =", round(T_obs, 4), "\n")
cat("p-value bootstrap =", round(p_value, 4), "\n")

#Simulasi Jurnal Acuan
library(tibble)
library(dplyr)
library(tidyr)

# Fungsi CV
cv <- function(x) sd(x) / mean(x)

# Parameter simulasi
n_list <- c(50, 100, 500, 1000, 5000)
sigma2_list <- seq(1, 5, by = 0.2)
B <- 1000  # atau 10000 untuk stabilitas lebih tinggi

# Simulasi
set.seed(123)
hasil <- tibble(n = numeric(), sigma2 = numeric(), p_value = numeric())

for (n in n_list) {
  for (sigma2 in sigma2_list) {
    x1 <- rnorm(n, mean = 1, sd = 3)
    x2 <- rnorm(n, mean = 1, sd = sigma2)
    
    T_obs <- abs(cv(x1) - cv(x2))
    combined <- c(x1, x2)
    
    T_boot <- numeric(B)
    for (b in 1:B) {
      boot1 <- sample(combined, n, replace = TRUE)
      boot2 <- sample(combined, n, replace = TRUE)
      T_boot[b] <- abs(cv(boot1) - cv(boot2))
    }
    
    pval <- mean(T_boot >= T_obs)
    hasil <- add_row(hasil, n = n, sigma2 = sigma2, p_value = pval)
  }
}

# Ubah ke format wide
tabel_wide <- hasil %>%
  mutate(sigma2 = round(sigma2, 1)) %>%
  pivot_wider(names_from = n, values_from = p_value, names_prefix = "n = ") %>%
  arrange(sigma2)

# Tampilkan hasil
print(tabel_wide, n = Inf)

