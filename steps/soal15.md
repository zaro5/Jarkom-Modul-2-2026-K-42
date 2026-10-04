# Langkah-Langkah

## Jalankan Script `abbey` dan `penny`

Buat file `soal15_penny.sh` dan `soal15_abbey.sh` di masing-masing container. Berikan izin eksekusi dan jalankan. Pastikan Apache2 running di PENNY dan Nginx running di ABBEY.

![alt text](../assets/15_penny-config.png)
![alt text](../assets/15_abbey-config.png)

## Uji Coba di `alpha`

Apabila pada container `abbey` dan `penny` tertera bahwa Apache2 dan Nginx telah running, bisa dilanjutkan dengan pengecekan Path `/eternal` di `penny` sebagai PHP Rendering, sementara lakukan pengecekan path `/orion` di `abbey` yang merupakan murni statis. 

Pada container `alpha`, jalankan `curl -i http://www.k42.com/eternal/` dengan harapan:

1. Status HTTP = 200 OK
2. Output text = `Eternal PHP Active on Penny!`
3. Tidak terlihat kode `<?php ... ?>`

Selanjutnya di container yang sama, jalankan `curl -i http://static.k42.com/orion/ hasil yang diharapkan adalah:

1. Status HTTP = 200 OK
2. Output text = `<h1>Orion Static Page on Abbey</h1>`
3. File yang berformat `.php` tidak akan dieksekusi.

- Curl `/eternal`
![alt text](../assets/15_alpha-curl-eternal.png)

- Curl `/orion`
![alt text](../assets/15_alpha-curl-orion.png)

### Catatan

Apabila link dari `http://...` kurang, maka status HTTP akan mengeluarkan kode 301 (Moved Permanently).

![alt text](../assets/15_alpha-301.png)