#!/bin/bash

# 1. Pastikan apache2-utils terinstal
apt update && apt install apache2-utils -y

# 2. Buat file .htpasswd dengan user prabs
htpasswd -cb /etc/apache2/.htpasswd prabs 'pakar_pinter_jadi_gob***'

# 3. Tambahkan blok <Location "/admin"> ke vault-proxy.conf secara aman (Python script untuk menghindari duplikasi)
python3 -c '
conf_path = "/etc/apache2/sites-available/vault-proxy.conf"
with open(conf_path, "r") as f:
    content = f.read()

if "<Location \"/admin\">" not in content:
    location_block = """
    <Location "/admin">
        AuthType Basic
        AuthName "Ruang Rahasia Sindikat"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>
    """
    new_content = content.replace("</VirtualHost>", location_block + "\n</VirtualHost>")
    with open(conf_path, "w") as f:
        f.write(new_content)
    print("Blok Location /admin berhasil ditambahkan.")
else:
    print("Blok Location /admin sudah ada.")
'

# 4. Aktifkan modul autentikasi Apache
a2enmod auth_basic authn_file authz_user

# 5. Uji konfigurasi dan restart Apache
apachectl configtest
service apache2 restart

echo "Setup Basic Auth di Penny Selesai!"