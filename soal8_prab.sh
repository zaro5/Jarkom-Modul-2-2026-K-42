#!/bin/bash

# Buat direktori jarkom jika belum ada
mkdir -p /etc/bind/jarkom

# 1. Konfigurasi named.conf.local untuk Master
cat > /etc/bind/named.conf.local <<'EOF'
zone "k42.com" {
    type master;
    notify yes;
    also-notify { 192.232.3.6; };
    allow-transfer { 192.232.3.6; };
    file "/etc/bind/jarkom/k42.com";
};

zone "2.232.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.232.3.6; };
    allow-transfer { 192.232.3.6; };
    file "/etc/bind/jarkom/2.232.192.in-addr.arpa";
};

zone "3.232.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.232.3.6; };
    allow-transfer { 192.232.3.6; };
    file "/etc/bind/jarkom/3.232.192.in-addr.arpa";
};

zone "4.232.192.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 192.232.3.6; };
    allow-transfer { 192.232.3.6; };
    file "/etc/bind/jarkom/4.232.192.in-addr.arpa";
};
EOF

# 2. Buat file zone reverse 2.232.192.in-addr.arpa (Penny)
cat > /etc/bind/jarkom/2.232.192.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.k42.com. root.k42.com. (
                        2024100201      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      prab.k42.com.
@       IN      NS      tedd.k42.com.
2       IN      PTR     penny.k42.com.
EOF

# 3. Buat file zone reverse 3.232.192.in-addr.arpa (Vault & Core)
cat > /etc/bind/jarkom/3.232.192.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.k42.com. root.k42.com. (
                        2024100201      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      prab.k42.com.
@       IN      NS      tedd.k42.com.
5       IN      PTR     vault.k42.com.
4       IN      PTR     vault.k42.com.
3       IN      PTR     core.k42.com.
2       IN      PTR     core.k42.com.
EOF

# 4. Buat file zone reverse 4.232.192.in-addr.arpa (Abbey)
cat > /etc/bind/jarkom/4.232.192.in-addr.arpa <<'EOF'
$TTL    604800
@       IN      SOA     prab.k42.com. root.k42.com. (
                        2024100201      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      prab.k42.com.
@       IN      NS      tedd.k42.com.
2       IN      PTR     abbey.k42.com.
EOF

# 5. Validasi dan Restart Bind9 di Prab
echo "Memvalidasi konfigurasi zone prab..."
named-checkzone 2.232.192.in-addr.arpa /etc/bind/jarkom/2.232.192.in-addr.arpa
named-checkzone 3.232.192.in-addr.arpa /etc/bind/jarkom/3.232.192.in-addr.arpa
named-checkzone 4.232.192.in-addr.arpa /etc/bind/jarkom/4.232.192.in-addr.arpa
named-checkconf

echo "Merestart layanan bind9 di prab..."
service bind9 restart || service named restart
echo "Setup Prab Selesai!"