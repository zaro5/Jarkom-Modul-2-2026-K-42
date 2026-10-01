#!/bin/bash

# 1. Aktifkan modul remoteip
a2enmod remoteip

# 2. Buat konfigurasi remoteip.conf
cat << 'EOF' > /etc/apache2/conf-available/remoteip.conf
RemoteIPHeader X-Real-IP
RemoteIPInternalProxy 192.232.2.2
EOF

# 3. Aktifkan konfigurasinya
a2enconf remoteip

# 4. Pastikan CustomLog ada di VirtualHost backend (k42.conf)
VHOST_BACKEND="/etc/apache2/sites-available/k42.conf"
if ! grep -q "CustomLog" "$VHOST_BACKEND"; then
    sed -i '/DocumentRoot/a\    CustomLog ${APACHE_LOG_DIR}/access.log combined' "$VHOST_BACKEND"
    echo "CustomLog berhasil ditambahkan ke vhost backend."
else
    echo "CustomLog sudah aktif di vhost backend."
fi

# 5. Uji konfigurasi dan restart Apache
apache2ctl configtest
service apache2 restart

echo "Setup Backend (Obladi/Desmond) untuk Soal 14 Selesai!"