# Soal 12
""Terdapat ruang khusus di penny yang yang menyimpan dokumen rahasia sindikat, oleh karena itu terapkan perlindungan basic authentication untuk path /admin. Akses ke jalur tersebut harus menolak pengunjung tanpa kredensial, dan hanya mengizinkan masuk jika menggunakan credential berikut:"

|username|password|
|---|---|
|prabs|pakar_pinter_jadi_gob***|

Penny adalah reverse proxy (Apache) yang meneruskan trafik ke area vault (Obladi & Desmond). Karena itu, basic authentication kita pasang di penny pada path /admin, sehingga setiap pengunjung akan dicek kredensialnya terlebih dahulu sebelum request diteruskan ke backend.

## Setup Penny
Pertama, kita perlu membuat file kredensial yang berisi user prabs beserta passwordnya. Password akan disimpan dalam bentuk hash. Tools htpasswd berasal dari paket apache2-utils.
```
apt update
apt install apache2-utils -y

htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'
cat /etc/apache2/.htpasswd
```

Setelah menjalankannya, hasilnya akan seperti berikut.
```
root@penny:~# apt update
Hit:1 http://deb.debian.org/debian trixie InRelease
Hit:2 http://deb.debian.org/debian trixie-updates InRelease
Hit:3 http://deb.debian.org/debian-security trixie-security InRelease
27 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@penny:~# apt install apache2-utils -y
apache2-utils is already the newest version (2.4.68-1~deb13u1).
apache2-utils set to manually installed.
Summary:
  Upgrading: 0, Installing: 0, Removing: 0, Not Upgrading: 27
root@penny:~#
root@penny:~# htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'
Adding password for user prabs
root@penny:~# cat /etc/apache2/.htpasswd
prabs:$apr1$N7cftK7b$NBm2bZgDs7.Lw8GCR5VSq/
```

Password perlu diapit dengan kutip satu supaya tanda *** tidak dianggap wildcard oleh shell. Opsi -c membuat file baru, jadi opsi ini tidak perlu dipakai lagi jika ingin menambah user lain.

Disini terlihat bahwa file .htpasswd berhasil dibuat dan isinya berbentuk prabs:$apr1$..., yang menandakan password sudah ter-hash.

Lalu, kita tambahkan aturan autentikasi ke dalam konfigurasi reverse proxy yang sudah dibuat sebelumnya, yaitu /etc/apache2/sites-available/vault-proxy.conf. Kita tambahkan blok <Location "/admin"> di dalam <VirtualHost>.
```
sed -i 's|</VirtualHost>|\n    <Location "/admin">\n        AuthType Basic\n        AuthName "Ruang Rahasia Sindikat"\n        AuthUserFile /etc/apache2/.htpasswd\n        Require valid-user\n    </Location>\n</VirtualHost>|' /etc/apache2/sites-available/vault-proxy.conf
```

Setelah dijalankan, hasilnya akan terlihat sebagai berikut.
```
root@penny:~# sed -i 's|</VirtualHost>|\n    <Location "/admin">\n        AuthType Basic\n        AuthName "Ruang Rahasia Sindikat"\n        AuthUserFile /etc/apache2/.htpasswd\n        Require valid-user\n    </Location>\n</VirtualHost>|' /etc/apache2/sites-available/vault-proxy.conf
root@penny:~# cat /etc/apache2/sites-available/vault-proxy.conf
<VirtualHost *:80>
    ServerName vault.k42.com
    ServerAlias www.k42.com k42.com penny.k42.com

    # Konfigurasi Load Balancer untuk Obladi & Desmond
    <Proxy balancer://vaultcluster>
        BalancerMember http://192.232.3.5
        BalancerMember http://192.232.3.4
        ProxySet lbmethod=byrequests
    </Proxy>

    # Forwarding traffic
    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

    # Meneruskan header Host dan X-Real-IP (Wajib)
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    <Location "/admin">
        AuthType Basic
        AuthName "Ruang Rahasia Sindikat"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

    <Location "/admin">
        AuthType Basic
        AuthName "Ruang Rahasia Sindikat"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>
</VirtualHost>
```

Setelah itu, kita aktifkan modul autentikasinya, mengecek konfigurasi, dan restart Apache.
```
a2enmod auth_basic authn_file authz_user
apachectl configtest
service apache2 restart
```

Setelah dijalankan, hasilnya seperti berikut.
```
root@penny:~# a2enmod auth_basic authn_file authz_user
apachectl configtest
service apache2 restart
Considering dependency authn_core for auth_basic:
Module authn_core already enabled
Module auth_basic already enabled
Module authn_file already enabled
Considering dependency authz_core for authz_user:
Module authz_core already enabled
Module authz_user already enabled
Syntax OK
Restarting Apache httpd web server: apache2.
```

Disini terlihat bahwa apachectl configtest menampilkan Syntax OK dan Apache berhasil di-restart.

## Testing & Verifikasi
Supaya setelah login pengunjung mendapatkan isi halaman, kita buat folder /admin di backend area vault. Jalankan berikut di Obladi dan Desmond.
```
mkdir -p /var/www/html/admin
echo "<h1>Dokumen Rahasia Sindikat</h1>" > /var/www/html/admin/index.html
```

Langkah ini tidak wajib untuk membuktikan autentikasi. Tanpa halaman ini, kredensial yang benar tetap lolos dari penny, hanya saja backend akan menjawab 404 Not Found.

Lalu, untuk melakukan verifikasi, pengujian dilakukan dari klien (alpha) dan wajib lewat hostname, bukan IP. Kita coba tiga skenario: tanpa kredensial, dengan password yang salah, dan dengan kredensial yang benar. Terakhir, kita cek path lain tetap bisa diakses tanpa login.
```
curl -i http://www.k42.com/admin/
curl -i -u 'prabs:salah' http://www.k42.com/admin/
curl -i -u 'prabs:pakar_pinter_jadi_gob***' http://www.k42.com/admin/
curl -sI http://www.k42.com/ | head -n 1
```

Setelah dijalankan, hasilnya akan terlihat sebagai berikut.
```
root@alpha:~# curl -i http://www.k42.com/admin/
curl -i -u 'prabs:salah' http://www.k42.com/admin/
curl -i -u 'prabs:pakar_pinter_jadi_gob***' http://www.k42.com/admin/
curl -sI http://www.k42.com/ | head -n 1
HTTP/1.1 401 Unauthorized
Date: Wed, 30 Sep 2026 15:14:38 GMT
Server: Apache/2.4.68 (Debian)
WWW-Authenticate: Basic realm="Area Rahasia Sindikat"
Content-Length: 498
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/st                                                                                                                                                                             rict.dtd">
<html><head>
<title>401 Unauthorized</title>
</head><body>
<h1>Unauthorized</h1>
<p>This server could not verify that you
are authorized to access the document
requested.  Either you supplied the wrong
credentials (e.g., bad password), or your
browser doesn't understand how to supply
the credentials required.</p>
<hr>
<address>Apache/2.4.68 (Debian) Server at www.k42.com Port 80</address>
</body></html>
HTTP/1.1 401 Unauthorized
Date: Wed, 30 Sep 2026 15:14:38 GMT
Server: Apache/2.4.68 (Debian)
WWW-Authenticate: Basic realm="Area Rahasia Sindikat"
Content-Length: 498
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/st                                                                                                                                                                             rict.dtd">
<html><head>
<title>401 Unauthorized</title>
</head><body>
<h1>Unauthorized</h1>
<p>This server could not verify that you
are authorized to access the document
requested.  Either you supplied the wrong
credentials (e.g., bad password), or your
browser doesn't understand how to supply
the credentials required.</p>
<hr>
<address>Apache/2.4.68 (Debian) Server at www.k42.com Port 80</address>
</body></html>
HTTP/1.1 200 OK
Date: Wed, 30 Sep 2026 15:14:38 GMT
Server: Apache/2.4.68 (Debian)
Last-Modified: Wed, 30 Sep 2026 14:30:18 GMT
ETag: "22-65cb423727f86"
Accept-Ranges: bytes
Content-Length: 34
Content-Type: text/html

<h1>Dokumen Rahasia Sindikat</h1>
HTTP/1.1 200 OK
```

Disini terlihat bahwa akses ke /admin tanpa kredensial maupun dengan password yang salah ditolak dengan status 401 Unauthorized beserta header WWW-Authenticate: Basic. Sementara itu, akses dengan user prabs dan password yang benar berhasil masuk dengan status 200 OK dan menampilkan isi halaman Dokumen Rahasia Sindikat. Path lain seperti / tetap bisa diakses tanpa login, yang menandakan proteksi hanya berlaku di path /admin.