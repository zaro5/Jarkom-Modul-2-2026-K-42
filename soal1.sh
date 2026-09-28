#!/bin/bash

# Pastikan script dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
  echo "Harap jalankan script ini sebagai root!"
  exit 1
fi

echo "[*] Membersihkan konfigurasi lama eth0..."
ip addr flush dev eth0
ip route flush dev eth0

echo "[*] Mengaktifkan interface eth0..."
ip link set dev eth0 up

echo "[*] Memasang IP Utama subnet NAT GNS3 (Contoh: 192.168.122.50)..."
# Catatan: Sesuaikan 192.168.122.50 dengan subnet DHCP/bridge NAT GNS3 Anda jika berbeda
ip addr add 192.168.122.50/24 dev eth0

echo "[*] Menambahkan IP Lab kustom sebagai IP Sekunder (192.232.1.10)..."
ip addr add 192.232.1.10/24 dev eth0

echo "[*] Memasang Default Gateway ke NAT GNS3..."
ip route add default via 192.168.122.1 dev eth0

echo "[*] Mengaktifkan Kernel IP Forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "[+] Konfigurasi selesai! Memeriksa status rute:"
ip route show
ip addr show eth0