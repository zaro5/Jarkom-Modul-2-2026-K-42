#!/bin/bash

# --- 1. Siapkan direktori dan file uji PHP untuk path /eternal ---
mkdir -p /var/www/eternal
echo "<?php echo 'Eternal PHP Active on Penny!'; ?>" > /var/www/eternal/index.php
chown -R www-data:www-data /var/www/eternal

# --- 2. Tulis ulang file konfigurasi VirtualHost Apache ---
cat << 'EOF' > /etc/apache2/sites-available/k42.com.conf
# --- VirtualHost untuk Redirection IP & penny.k42.com ke www.k42.com (Tahap 13) ---
<VirtualHost *:80>
    ServerName penny.k42.com
    ServerAlias 192.232.2.2
    
    # Paksa redirect permanen (301) ke domain kanonik www.k42.com
    Redirect 301 / http://www.k42.com/
</VirtualHost>

# --- VirtualHost Utama / Reverse Proxy untuk Vault & www ---
<VirtualHost *:80>
    ServerName www.k42.com
    ServerAlias vault.k42.com

    ProxyPreserveHost On

    # Konfigurasi Load Balancing ke Backend Obladi & Desmond
    <Proxy balancer://vaultcluster>
        BalancerMember http://192.232.3.5
        BalancerMember http://192.232.3.4
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

    # --- Perlindungan Basic Authentication untuk Path /admin (Tahap 12) ---
    <Location /admin>
        AuthType Basic
        AuthName "Area Rahasia Sindikat"
        AuthUserFile /etc/apache2/secure/.htpasswd
        Require valid-user
    </Location>

    # --- Tahap 15: Jalur khusus /eternal dengan dukungan PHP ---
    Alias /eternal /var/www/eternal
    <Directory /var/www/eternal>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
EOF

# --- 3. Aktifkan site dan restart Apache ---
a2ensite k42.com.conf
apache2ctl configtest
service apache2 reload
service apache2 restart
service apache2 status

echo "Konfigurasi Penny (Tahap 15 /eternal) Berhasil Dijalankan!"
