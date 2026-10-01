#!/bin/bash

ZONE_FILE="/etc/bind/jarkom/k42.com"

# 1. Ambil nomor serial saat ini menggunakan grep dan sed
CURRENT_SERIAL=$(grep -A1 "Serial" "$ZONE_FILE" | grep -o '[0-9]\+')
if [ -z "$CURRENT_SERIAL" ]; then
    echo "Error: Gagal mendeteksi nomor serial SOA!"
    exit 1
fi

NEW_SERIAL=$((CURRENT_SERIAL + 1))
echo "Serial lama: $CURRENT_SERIAL -> Serial baru: $NEW_SERIAL"

# 2. Tambahkan TXT Record jika belum ada di file zone
if ! grep -q "--- TXT Record Klien Sayap Kiri dan Kanan ---" "$ZONE_FILE"; then
    cat >> "$ZONE_FILE" <<'EOF'

; --- TXT Record Klien Sayap Kiri dan Kanan ---
alpha   IN  TXT     "alpha"
beta    IN  TXT     "beta"
gamma   IN  TXT     "gamma"
delta   IN  TXT     "delta"
epsilon IN  TXT     "epsilon"
EOF
    echo "TXT record berhasil ditambahkan ke file zone."
else
    echo "TXT record sudah ada di dalam file zone."
fi

# 3. Timpa nomor serial lama dengan yang baru
sed -i "s/$CURRENT_SERIAL/$NEW_SERIAL/g" "$ZONE_FILE"

# 4. Validasi dan Restart BIND9
named-checkzone k42.com "$ZONE_FILE"
named-checkconf

echo "Merestart layanan BIND9..."
service bind9 restart || service named restart

echo "Setup Prab untuk Soal 17 Selesai! Serial aktif saat ini: $NEW_SERIAL"