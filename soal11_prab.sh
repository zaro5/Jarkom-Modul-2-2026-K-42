#!/bin/bash

# --- 1. Buat direktori jika belum ada ---
mkdir -p /etc/bind/jarkom

# --- 2. Tulis ulang file zone k42.com ---
cat << 'EOF' > /etc/bind/jarkom/k42.com
;
; BIND data file for k42.com
;
$TTL    604800
@       IN  SOA     prab.k42.com. root.k42.com. (
                        2024100205      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN  NS      prab.k42.com.
@       IN  NS      tedd.k42.com.
@       IN  A       192.232.2.2     ; penny (gerbang aplikasi dinamis)
vault   IN  A       192.232.2.2     ; Mengarah ke Penny (Apache Proxy)
core    IN  A       192.232.4.2     ; Mengarah ke Abbey (Nginx Proxy)
prab    IN  A       192.232.3.7
tedd    IN  A       192.232.3.6
rootkit IN  A       192.232.1.1
alpha   IN  A       192.232.5.4
beta    IN  A       192.232.5.3
gamma   IN  A       192.232.5.2
delta   IN  A       192.232.1.2
epsilon IN  A       192.232.1.3
abbey   IN  A       192.232.4.2
penny   IN  A       192.232.2.2
obladi  IN  A       192.232.3.5
desmond IN  A       192.232.3.4
oblada  IN  A       192.232.3.3
molly   IN  A       192.232.3.2

; --- CNAME Record ---
www     IN  CNAME   penny
static  IN  CNAME   abbey
EOF

# --- 3. Validasi dan Restart BIND9 ---
named-checkzone k42.com /etc/bind/jarkom/k42.com
systemctl restart bind9
echo "DNS Gateway Reverse Proxy (Prab) Berhasil Diperbarui!"