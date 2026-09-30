# Soal 17
"Tambahkan TXT record pada DNS untuk semua klien sayap kiri dan sayap kanan (Alpha, Beta, Gamma, Delta, Epsilon). Jika DNS di-query TXT terhadap nama domain mereka (contoh: alpha.<xxxx>.com), sistem harus mengembalikan teks berupa nama hostname mereka masing-masing (contoh: "alpha")."

## Setup Prab
Jalankan berikut untuk mengecek serial zona sekarang
```
grep -A1 "Serial" /etc/bind/jarkom/k42.com
```

Dari sini terlihat bahwa untuk sekarang, serial zonanya adalah sebagai berikut.
```
root@prab:~# grep -A1 "Serial" /etc/bind/jarkom/k42.com
                        2024100205      ; Serial
                        604800          ; Refresh

```

Berikut, kita tambahkan record kepada zona dengan kode berikut.
```
cat >> /etc/bind/jarkom/k42.com <<'EOF'

; --- TXT Record Klien Sayap Kiri dan Kanan ---
alpha   IN  TXT     "alpha"
beta    IN  TXT     "beta"
gamma   IN  TXT     "gamma"
delta   IN  TXT     "delta"
epsilon IN  TXT     "epsilon"
EOF
```

Setelah itu, kita naikkan serial supaya tedd menarik ulang.
```
sed -i 's/2024100205/2024100206/' /etc/bind/jarkom/k42.com
grep -A1 "Serial" /etc/bind/jarkom/k42.com
```

Setelah menjalankan itu, serial zona sekarang akan menjadi 206.
```
root@prab:~# sed -i 's/2024100205/2024100206/' /etc/bind/jarkom/k42.com
grep -A1 "Serial" /etc/bind/jarkom/k42.com
                        2024100206      ; Serial
                        604800          ; Refresh
```

Lalu, kita restart dan verifikasi hasilnya.
```
named-checkzone k42.com /etc/bind/jarkom/k42.com
named-checkconf
service named restart
dig TXT alpha.k42.com @127.0.0.1 +short
```

Hasilnya harusnya seperti berikut.
```
root@prab:~# named-checkzone k42.com /etc/bind/jarkom/k42.com
named-checkconf
service named restart
dig TXT alpha.k42.com @127.0.0.1 +short
zone k42.com/IN: loaded serial 2024100206
OK
Stopping domain name service...: namedwaiting for pid 137 to die
.
Starting domain name service...: named.
"alpha"
```

Serial harus 206, named-checkzone harus berakhir OK, dan dig terakhir menampilkan "alpha".

## Verifikasi Tedd
Setelah selesai setup prab, kita verifikasi dulu di tedd apakah tedd sudah ikut terupdate atau belum
```
dig k42.com SOA @127.0.0.1 +short
```

```
root@tedd:~# dig k42.com SOA @127.0.0.1 +short
prab.k42.com. root.k42.com. 2024100206 604800 86400 2419200 604800
```
Disini terlihat serial berhasil terupdate menjadi 206.

Dan untuk mengecek apakah TXT record berhasil, jalankan berikut.
```
dig TXT beta.k42.com @127.0.0.1 +short
dig TXT gamma.k42.com @127.0.0.1 +short
dig TXT delta.k42.com @127.0.0.1 +short
dig TXT epsilon.k42.com @127.0.0.1 +short
```

Jika benar dan berhasil, hasilnya seperti ini
```
root@tedd:~# dig TXT beta.k42.com @127.0.0.1 +short
dig TXT gamma.k42.com @127.0.0.1 +short
dig TXT delta.k42.com @127.0.0.1 +short
dig TXT epsilon.k42.com @127.0.0.1 +short
"beta"
"gamma"
"delta"
"epsilon"
```

## Verifikasi Tambahan
Dan untuk verifikasi terakhir, kita jalankan juga di node Alpha, Beta, dst.
```
dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
```

Node Alpha
```
root@alpha:~# dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
"alpha"
"beta"
"gamma"
"delta"
"epsilon"
192.232.5.4
```

Node Beta
```
root@beta:~# dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
"alpha"
"beta"
"gamma"
"delta"
"epsilon"
192.232.5.4
```

Node Gamma
```
root@gamma:~# dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
"alpha"
"beta"
"gamma"
"delta"
"epsilon"
192.232.5.4
```

Node Delta
```
root@delta:~# dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
"alpha"
"beta"
"gamma"
"delta"
"epsilon"
192.232.5.4
```

Node Epsilon
```
root@epsilon:~# dig TXT alpha.k42.com +short
dig TXT beta.k42.com +short
dig TXT gamma.k42.com +short
dig TXT delta.k42.com +short
dig TXT epsilon.k42.com +short
dig alpha.k42.com +short
"alpha"
"beta"
"gamma"
"delta"
"epsilon"
192.232.5.4
```