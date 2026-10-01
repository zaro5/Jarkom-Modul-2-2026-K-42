#!/bin/bash

# 1. Aktifkan modul headers di Apache
a2enmod headers

# 2. Tentukan path file VirtualHost (sesuaikan jika nama file vhost Anda berbeda)
VHOST_FILE="/etc/apache2/sites-available/k42.com.conf"

# 3. Sisipkan RequestHeader X-Real-IP secara aman jika belum ada
if ! grep -q "X-Real-IP" "$VHOST_FILE"; then
    sed -i '/ProxyPreserveHost On/a\    RequestHeader set X-Real-IP "expr=%{REMOTE_ADDR}"' "$VHOST_FILE"
    echo "Baris RequestHeader X-Real-IP berhasil ditambahkan."
else
    echo "Baris RequestHeader X-Real-IP sudah ada di konfigurasi."
fi

# 4. Tes konfigurasi dan restart Apache
apache2ctl configtest
service apache2 restart

echo "Setup Penny (Gateway) untuk Soal 14 Selesai!"