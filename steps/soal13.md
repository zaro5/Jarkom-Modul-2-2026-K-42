# Langkah-Langkah

## Jalankan script `abbey` dan `penny`

Buatlah file `soal13_abbey.sh` dan `soal13_penny.sh` di masing-masing container. Berikan izin eksekusi dan jalankan.

![alt text](../assets/13_abbey-config.png)
![alt text](../assets/13_penny-config.png)

## Uji coba di `penny`

Setelah memastikan script berjalan tanpa kendala, lakukan uji coba di `alpha`.

- Curl ke `abbey`

    ```bash 
    curl http://192.232.4.2/
    curl http://abbey.k42.com/
    ```
    
    ![alt text](../assets/13_curl-abbey.png)

- Curl ke `penny`

    ```bash
    curl http://192.232.2.2/
    curl http://penny.k42.com/
    ```

    ![alt text](../assets/13_curl-penny.png)