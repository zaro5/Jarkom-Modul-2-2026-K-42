# Install Apache2
apt update
apt install apache2 -y

# Bikin direktori /arsip/ dan masukkan dummy
mkdir -p /var/www/html/arsip

echo "Dokumen Arsip 1" > /var/www/html/arsip/file1.txt
echo "Dokumen Arsip 2" > /var/www/html/arsip/file2.txt

#Buka file config virtual host Apache
cat << 'EOF' > /etc/apache2/sites-available/k42.conf
<VirtualHost *:80>
    ServerName vault.k42.com
    DocumentRoot /var/www/html

    <Directory /var/www/html/arsip>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

#Aktivasi file config virtual
a2ensite k42.conf

#Non aktifkan halaman bawaan default Apache
a2dissite 000-default.conf

#Restart web server Apachenya
service apache2 restart

#Cek statusnya
service apache2 status