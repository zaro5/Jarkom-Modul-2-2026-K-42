# Soal 14
"Di dalam The Mesh, rekam jejak tidak boleh dipalsukan oleh sistem. Pastikan access log pada setiap server web di area vault maupun area core mencatat alamat IP asli milik client (pengunjung) yang diteruskan oleh gerbang, dan bukan mencatat IP dari Penny ataupun Abbey."

Untuk mengerjakan soal ini, pertama kita perlu mengedit k.k42.com.conf dari Penny supaya X-Real-IP kembali dikirim, lalu di restart. Untuk melakukannya, jalankan kode berikut.

## Setup Penny
```
a2enmod headers

# Sisipkan header setelah ProxyPreserveHost di VirtualHost www/vault
sed -i '/ProxyPreserveHost On/a\    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"' /etc/apache2/sites-available/k42.com.conf

apache2ctl configtest
service apache2 restart
```

Setelah menjalankan kodenya, akan muncul seperti berikut.
```
root@penny:~# a2enmod headers

# Sisipkan header setelah ProxyPreserveHost di VirtualHost www/vault
sed -i '/ProxyPreserveHost On/a\    RequestHeader set X-Real-IP "expr=%{REMOTE_A                                                                                                                                                                             DDR}"' /etc/apache2/sites-available/k42.com.conf

apache2ctl configtest
service apache2 restart
Module headers already enabled
Syntax OK
Restarting Apache httpd web server: apache2.
```

Dari kode ini, set menimpa header apa pun yang dikirim client, jadi client tidak bisa memalsukan X-Real-IP. Apache juga otomatis menambahkan X-Forwarded-For lewat mod_proxy_http.

Penny sudah selesai di setup, terlihat dari modul headers aktif, sintaks OK, dan Apache berhasil restart. Tetapi karena sed tidak menampilkan output, pastikan dulu barisnya benar-benar masuk
```
grep -n -B1 -A1 "X-Real-IP" /etc/apache2/sites-available/k42.com.conf
```

Jika berhasil, maka hasilnya akan seperti berikut.
```
root@penny:~# grep -n -B1 -A1 "X-Real-IP" /etc/apache2/sites-available/k42.com.conf
15-    ProxyPreserveHost On
16:    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"
17-
```

Disini terlihat munculnya line 'RequestHeader ...' yang berarti sudah berjalan dengan sukses.

## Setup Obladi dan Desmond
Setelah selesai setup Penny, kita baru setup Obladi dan Desmond dengan menggunakan kode berikut.
```
a2enmod remoteip

cat << 'EOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.232.2.2
EOF
a2enconf remoteip

# Vhost k42.conf belum punya CustomLog, jadi tambahkan supaya access.log terisi
grep -q CustomLog /etc/apache2/sites-available/k42.conf || \
sed -i '/DocumentRoot/a\    CustomLog ${APACHE_LOG_DIR}/access.log combined' /etc/apache2/sites-available/k42.conf

apache2ctl configtest
service apache2 restart
```

Hasilnya akan terlihat sebagai berikut di keduanya masing-masing.
```
root@obladi:~# a2enmod remoteip

cat << 'EOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.232.2.2
EOF
a2enconf remoteip

grep -q CustomLog /etc/apache2/sites-available/k42.conf || \
sed -i '/DocumentRoot/a\    CustomLog ${APACHE_LOG_DIR}/access.log combined' /etc/apache2/sites-available/k42.conf

apache2ctl configtest
service apache2 restart
Enabling module remoteip.
To activate the new configuration, you need to run:
  service apache2 restart
Enabling conf remoteip.
To activate the new configuration, you need to run:
  service apache2 reload
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
Restarting Apache httpd web server: apache2AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
.
```
```
root@desmond:~# a2enmod remoteip

cat << 'EOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.232.2.2
EOF
a2enconf remoteip

grep -q CustomLog /etc/apache2/sites-available/k42.conf || \
sed -i '/DocumentRoot/a\    CustomLog ${APACHE_LOG_DIR}/access.log combined' /etc/apache2/sites-available/k42.conf

apache2ctl configtest
service apache2 restart
Module remoteip already enabled
Conf remoteip already enabled
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
Restarting Apache httpd web server: apache2AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
.
```

Terlihat line Syntax OK yang berarti config berhasil.

## Verifikasi Logs
Setelah selesai setup, kita baru bisa mengetes secara cepat dari client lain untuk mengecek apakah Obladi dan Desmond tersebut dapat melihat file access.log di curl. Untuk melakukannya, kita mencoba tesnya di dalam node Alpha dan menjalankan berikut
```
curl -s -o /dev/null -w "%{http_code}\n" http://vault.k42.com/
```

Sekaligus kita menjalankan kode ini di Alpha, kita jalankan
```
tail -f /var/log/apache2/access.log
```

Di Obladi dan Desmond. Dikarenakan file Alpha berada pada IP 192.232.5.4, maka logs yang tercatat harus dari IP tersebut. Jika berhasil untuk ditangkap, maka hasilnya akan sebagai berikut.
```
root@obladi:~# tail -f /var/log/apache2/access.log
192.232.5.4 - - [30/Sep/2026:15:41:35 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:41:36 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:43:33 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:43:36 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:43:36 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:43:37 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:14 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:14 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:49 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:49 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:50:56 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:51:02 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:51:07 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
^C

root@desmond:~# tail -f /var/log/apache2/access.log
192.232.5.4 - - [30/Sep/2026:15:59:14 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:15 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:49 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:15:59:49 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:50:58 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:51:05 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:51:48 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:52:00 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:52:03 +0000] "GET / HTTP/1.1" 200 11014 "-" "curl/8.14.1"
192.232.5.4 - - [30/Sep/2026:16:52:05 +0000] "GET / HTTP/1.1" 200 11013 "-" "curl/8.14.1"
^C
```

Disini terlihat bahwa Obladi dan Desmond berhasil untuk menangkap access.log yang di cull oleh Alpha, yaitu IP 192.232.5.4.