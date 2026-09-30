# Instalasi Nginx
apt update
apt install nginx -y

# Konfigurasi Nginx
cat << 'EOF' > /etc/nginx/sites-available/core-proxy.conf
upstream corecluster {
    # Daftarkan node Oblada dan Molly
    server 192.232.3.3;
    server 192.232.3.2;
}

server {
    listen 80;
    server_name core.k42.com;

    location / {
        proxy_pass http://corecluster;

        # Meneruskan header Host dan X-Real-IP (Wajib)
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

# Aktivasi
ln -s /etc/nginx/sites-available/core-proxy.conf /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Uji sintaks agar tidak ada typo
nginx -t

# Restart layanan
service nginx restart
service nginx status