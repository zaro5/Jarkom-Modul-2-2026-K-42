# --- 1. Buat direktori dan file uji statis untuk path /orion ---
mkdir -p /var/www/orion
echo "<h1>Orion Static Page on Abbey</h1>" > /var/www/orion/index.html
chown -R www-data:www-data /var/www/orion

# --- 2. Bersihkan sites-enabled agar tidak ada konflik server name ---
rm -f /etc/nginx/sites-enabled/*

# --- 3. Tulis ulang file konfigurasi Nginx untuk Abbey ---
cat << 'EOF' > /etc/nginx/sites-available/k42.com
upstream backend_cluster {
    server 192.232.3.2; # molly
    server 192.232.3.3; # oblada
}

# --- Blok 1: Redirection Sementara (302) untuk IP & abbey.k42.com (Tahap 13) ---
server {
    listen 80;
    server_name abbey.k42.com 192.232.4.2;
    return 302 http://static.k42.com$request_uri;
}

# --- Blok 2: Konfigurasi Reverse Proxy Utama & Path /orion (Tahap 11 & 15) ---
server {
    listen 80;
    server_name static.k42.com core.k42.com;

    # --- Tahap 15: Jalur khusus /orion secara murni statis ---
    location /orion {
        alias /var/www/orion;
        index index.html index.htm;
        try_files $uri $uri/ =404;
    }

    # --- Konfigurasi Proxy Utama ---
    location / {
        proxy_pass http://backend_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# --- 4. Aktifkan konfigurasi ---
ln -sf /etc/nginx/sites-available/k42.com /etc/nginx/sites-enabled/k42.com

# --- 5. Uji dan Restart Nginx ---
nginx -t && service nginx restart
service nginx status

echo "Konfigurasi Abbey (Tahap 15 /orion) Berhasil Dijalankan!"