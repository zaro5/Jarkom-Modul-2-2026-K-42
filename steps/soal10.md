# Langkah-Langkah

## Jalankan cript `oblada` dan `molly`

Buat file script `soal10_oblada.sh` `soal10_molly.sh` dan berikan izin eksekusi, kemudian jalankan. Pastikan Nginx berhaasil running.

![alt text](../assets/10_molly-nginx-running.png)
![alt text](../assets/10_oblada-nginx-running.png)

## Uji curl `beranda` dan `profil`

Di dalam script untuk `oblada` dan `molly` terdapat pembuatan file `index.php` dan `profil.php`.

Jalankan uji coba dengan perintah:

```bash
curl --resolve <domain>:80:<IP WEB SERVER> <domain>
```

![alt text](../assets/10_alpha-curl-beranda.png)
![alt text](../assets/10_alpha-curl-profil.png)
