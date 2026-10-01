#!/bin/bash

# 1. Konfigurasi named.conf.local untuk Slave
cat >> /etc/bind/named.conf.local <<'EOF'

zone "2.232.192.in-addr.arpa" {
    type slave;
    masters { 192.232.3.7; };
    file "/var/lib/bind/2.232.192.in-addr.arpa";
};

zone "3.232.192.in-addr.arpa" {
    type slave;
    masters { 192.232.3.7; };
    file "/var/lib/bind/3.232.192.in-addr.arpa";
};

zone "4.232.192.in-addr.arpa" {
    type slave;
    masters { 192.232.3.7; };
    file "/var/lib/bind/4.232.192.in-addr.arpa";
};
EOF

# 2. Validasi dan Restart Bind9 di Tedd
echo "Memvalidasi konfigurasi tedd..."
named-checkconf

echo "Merestart layanan bind9 di tedd..."
service bind9 restart || service named restart

# 3. Tunggu beberapa detik untuk zone transfer
echo "Menunggu sinkronisasi zone transfer (5 detik)..."
sleep 5

# 4. Cek file hasil transfer
ls -l /var/lib/bind/

echo "Setup Tedd Selesai! Jalankan perintah dig -x untuk verifikasi."