# Langkah-Langkah

## Jalankan cript `oblada` dan `molly`

Buat file script `soal10_oblada.sh` `soal10_molly.sh` dan berikan izin eksekusi, kemudian jalankan. Pastikan Nginx berhaasil running.

![alt text](../assets/10_molly-nginx-running.png)
![alt text](../assets/10_oblada-nginx-running.png)

## Uji curl `beranda` dan `profil`

Di dalam script untuk `oblada` dan `molly` terdapat pembuatan file `index.php` dan `profil.php`.

Jalankan dengan perintah `curl <domain>`,  namun apabila node alpha belum terhubung dengan node `oblada`, maka bisa menggunakan `curl --resolve <domain>:80:<IP WEB SERVER> <domain>`.

```bash
curl http://core.k42.com/
curl http://core.k42.com/profil
```

![alt text](../assets/10_alpha-curl-beranda.png)
![alt text](../assets/10_alpha-curl-profil.png)
