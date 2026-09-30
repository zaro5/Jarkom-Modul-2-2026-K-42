# --- 1. Pastikan modul Apache yang dibutuhkan aktif ---
a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests auth_basic authn_file authz_user

# --- 2. Buat direktori dan file .htpasswd untuk Tahap 12 (jika belum ada) ---
mkdir -p /etc/apache2/secure
htpasswd -bc /etc/apache2/secure/.htpasswd prabs pakar_pinter_jadi_gob***

# --- 3. Buat file konfigurasi VirtualHost lengkap di Penny ---
cat << 'EOF' > /etc/apache2/sites-available/k42.com.conf
# --- VirtualHost untuk Redirection IP & Penny.k42.com ke www.k42.com (Tahap 13) ---
<VirtualHost *:80>
    ServerName penny.k42.com
    ServerAlias 192.232.2.2
    
    # Paksa redirect permanen (301) ke domain kanonik www.k42.com
    Redirect 301 / http://www.k42.com/
</VirtualHost>

# --- VirtualHost Utama / Reverse Proxy untuk Vault & www (Tahap 7 & 11) ---
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
</VirtualHost>
EOF

# --- 4. Pastikan site aktif dan restart Apache ---
a2dissite 000-default.conf
a2ensite k42.com.conf
apache2ctl configtest
service apache2 reload
service apache2 restart
service apache2 status

echo "HELL YAEAH"