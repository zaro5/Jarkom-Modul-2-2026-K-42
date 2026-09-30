# Instalasi
apt update
apt install apache2 -y

a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests headers

# Buat konfigurasi VirtualHost
cat << 'EOF' > /etc/apache2/sites-available/vault-proxy.conf
<VirtualHost *:80>
    ServerName vault.k42.com

    # Konfigurasi Load Balancer untuk Obladi & Desmond
    <Proxy balancer://vaultcluster>
        BalancerMember http://<IP_OBLADI>
        BalancerMember http://<IP_DESMOND>
        ProxySet lbmethod=byrequests
    </Proxy>

    # Forwarding traffic
    ProxyPass / balancer://vaultcluster/
    ProxyPassReverse / balancer://vaultcluster/

    # Meneruskan header Host dan X-Real-IP (Wajib)
    ProxyPreserveHost On
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"
</VirtualHost>
EOF

# Aktifkan konfigurasi
a2ensite vault-proxy.conf

# Nonaktifkan site default
a2dissite 000-default.conf

apache2ctl configtest
service apache2 restart
service apache2 status