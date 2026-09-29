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

Untuk melakukan pembuktian jika sudah masuk, jalankan berikut
```
hostname
hostname -f
cat /etc/hostname
getent hosts $(hostname)
```

Jika berhasil, akan terlihat seperti berikut
![alt text](/assets/5_alpha.png)

## Setup node Rootkit
```
echo 'rootkit' > /etc/hostname
hostname rootkit

echo '127.0.0.1 localhost
192.232.1.1 rootkit.k42.com rootkit' > /etc/hosts
```

## Setup node Beta
```
echo 'beta' > /etc/hostname
hostname beta

echo '127.0.0.1 localhost
192.232.5.3 beta.k42.com beta' > /etc/hosts
```

## Setup node Gamma
```
echo 'gamma' > /etc/hostname
hostname gamma

echo '127.0.0.1 localhost
192.232.5.2 gamma.k42.com gamma' > /etc/hosts
```

## Setup node Abbey
```
echo 'abbey' > /etc/hostname
hostname abbey

echo '127.0.0.1 localhost
192.232.4.2 abbey.k42.com abbey' > /etc/hosts
```

## Setup node Obladi
```
echo 'obladi' > /etc/hostname
hostname obladi

echo '127.0.0.1 localhost
192.232.3.5 obladi.k42.com obladi' > /etc/hosts
```

## Setup node Desmond
```
echo 'desmond' > /etc/hostname
hostname desmond

echo '127.0.0.1 localhost
192.232.3.4 desmond.k42.com desmond' > /etc/hosts
```

## Setup node Oblada
```
echo 'oblada' > /etc/hostname
hostname oblada

echo '127.0.0.1 localhost
192.232.3.3 oblada.k42.com oblada' > /etc/hosts
```

## Setup node Molly
```
echo 'molly' > /etc/hostname
hostname molly

echo '127.0.0.1 localhost
192.232.3.2 molly.k42.com molly' > /etc/hosts
```

## Setup node Penny
```
echo 'penny' > /etc/hostname
hostname penny

echo '127.0.0.1 localhost
192.232.2.2 penny.k42.com penny' > /etc/hosts
```
## Setup node Epsilon
```
echo 'epsilon' > /etc/hostname
hostname epsilon

echo '127.0.0.1 localhost
192.232.1.3 epsilon.k42.com epsilon' > /etc/hosts
```

## Setup node Delta
```
echo 'delta' > /etc/hostname
hostname delta

echo '127.0.0.1 localhost
192.232.1.2 delta.k42.com delta' > /etc/hosts
```

## Setup node Tedd
```
echo 'tedd' > /etc/hostname
hostname tedd

echo '127.0.0.1 localhost
192.232.3.6 tedd.k42.com tedd' > /etc/hosts
```

## Setup node Prab
```
echo 'prab' > /etc/hostname
hostname prab

echo '127.0.0.1 localhost
192.232.3.7 prab.k42.com prab' > /etc/hosts
```

## Setup Domain
Terakhir, kita perlu untuk setup di prab untuk menambahkan nama-nama entitas lainnya, cukup tambahkan line-line berikut ke dalam /etc/bind/jarkom/k42.com (tedd tidak perlu di setup karena tedd adalah slave)
```
# Kita juga perlu mengganti nomor serial di dalam kodenya dari 201 menjadi 202 untuk menandakan kode sudah diganti
rootkit IN      A       192.232.1.1
alpha   IN      A       192.232.5.4
beta    IN      A       192.232.5.3
gamma   IN      A       192.232.5.2
delta   IN      A       192.232.1.2
epsilon IN      A       192.232.1.3
abbey   IN      A       192.232.4.2
penny   IN      A       192.232.2.2
obladi  IN      A       192.232.3.5
desmond IN      A       192.232.3.4
oblada  IN      A       192.232.3.3
molly   IN      A       192.232.3.2

# Lalu jalankan berikut untuk restart
named-checkzone k42.com /etc/bind/jarkom/k42.com
service named restart
```

Setelah di save, kita cukup menjalankan kode berikut di dalam tedd untuk mengecek apakah kode di tedd juga sudah terupdate
```
ls -l /var/lib/bind/
dig alpha.k42.com @127.0.0.1
```
![alt text](/assets/5_verifikasitedd.png)
Disini terlihat bahwa status dari dig tersebut adalah `NOERROR` dan juga muncul ip dari alpha yang menandakan bahwa tedd berhasil mengikuti prab dan hasilnya terupdate. Dari sini juga terlihat bahwa domain dengan nama dari webnya juga berhasil di implementasi dilihat dari nama domainnya (untuk contoh ini alpha.k42.com) dan juga terlihat ip dari domainnya (yaitu 192.232.5.4)