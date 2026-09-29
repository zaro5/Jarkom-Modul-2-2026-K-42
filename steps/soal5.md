# Soal 5
"Namai semua Entitas (hostname) sesuai glosarium: rootkit, alpha, beta, gamma, delta, epsilon, prab, tedd, abbey, penny, obladi, desmond, oblada, molly, dan verifikasi bahwa setiap host mengenali hostname tersebut secara system-wide. Buat setiap domain untuk masing-masing node sesuai dengan namanya (contoh: alpha.<xxxx>.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas prab dan tedd."

Untuk menambahkan hostname setiap entitas ke dalam domainnya, kita perlu untuk set hostname ke dalam `/etc/hostname` dan supaya bisa dikenali secara system-wide, kita juga perlu menambahka nama dan ip dari nodenya ke dalam `/etc/hosts`

## Setup di node Alpha
Setup hostname
```
echo 'alpha' > /etc/hostname
hostname alpha
```

Setup nama dan IP supaya bisa dinekali secara system-wide (127.0.0.1)
```
echo '127.0.0.1 localhost
192.232.5.4 alpha.k42.com alpha' > /etc/hosts
```