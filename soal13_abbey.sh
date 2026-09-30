#!/bin/bash

# --- 1. Buat direktori konfigurasi Nginx jika belum ada ---
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# --- 2. Tulis file konfigurasi Nginx untuk Abbey ---
cat << 'EOF' > /etc/nginx/sites-available/k42.com
# --- Definisikan Upstream Backend untuk Abbey ---
upstream backend_cluster {
    server 192.232.3.2; # molly
    server 192.232.3.3; # oblada
}

# --- Blok 1: Redirection Sementara (302) untuk IP & abbey.k42.com (Tahap 13) ---
server {
    listen 80;
    server_name abbey.k42.com 192.232.4.2;

    # Redirect sementara (302) ke domain kanonik static.k42.com
    return 302 http://static.k42.com$request_uri;
}

# --- Blok 2: Konfigurasi Reverse Proxy / Load Balancing Utama (Tahap 7 & 11) ---
server {
    listen 80;
    server_name static.k42.com core.k42.com;

    location / {
        proxy_pass http://backend_cluster;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# --- 3. Pastikan site diaktifkan dan tautkan ke sites-enabled ---
ln -sf /etc/nginx/sites-available/k42.com /etc/nginx/sites-enabled/

# --- 4. Hapus default site Nginx jika ada konflik ---
rm -f /etc/nginx/sites-enabled/default

# --- 5. Uji konfigurasi dan restart Nginx ---
nginx -t
service nginx restart
service nginx status

echo "Konfigurasi Abbey (Tahap 13 Redirection & Proxy) Berhasil Dijalankan!"