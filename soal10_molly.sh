# Instalasi nginx
apt update
apt install nginx php-fpm -y

# Buat file /var/www/html/index.php
cat << 'EOF' > /var/www/html/index.php
<!DOCTYPE html>
<html>
<head><title>Beranda Core</title></head>
<body>
    <h1>Selamat Datang di Beranda Core</h1>
    <p>Ini adalah halaman utama area core.</p>
    <a href="/profil">Menuju Halaman Profil</a>
</body>
</html>
EOF

# Buat file profil.php
cat << 'EOF' > /var/www/html/profil.php
<!DOCTYPE html>
<html>
<head><title>Profil</title></head>
<body>
    <h1>Halaman Profil Pengguna</h1>
    <p>Ini adalah halaman profil yang diakses menggunakan URL bersih (tanpa .php).</p>
    <a href="/">Kembali ke Beranda</a>
</body>
</html>
EOF

# Buat konfigurasi untuk Nginx di core.conf
cat << 'EOF' > /etc/nginx/sites-available/core.conf
server {
    listen 80;
    server_name core.k42.com; # Sesuaikan hostname core Anda

    root /var/www/html;
    index index.php index.html;

    location / {
        # Otomatis mencoba mencocokkan uri, direktori, atau file .php (URL bersih)
        try_files $uri $uri/ $uri.php =404;
    }

    # Eksekusi script PHP melalui PHP-FPM
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        # Sesuaikan versi socket PHP jika diperlukan (misal: php8.2-fpm.sock)
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }
}
EOF

ln -s /etc/nginx/sites-available/core.conf /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Uji syntax configurasi
# Nanti hasilnya [....syntax is ok]
nginx -t

# Restart nginx
service nginx restart
service nginx status