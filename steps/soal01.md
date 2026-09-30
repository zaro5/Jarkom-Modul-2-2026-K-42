# Langkah-Langkah

## Melakukan config pada rootkit

Untuk melakukan ping dan confignya, buka konfigurasi pada rootkit dengan perintah `nano /etc/networks/interfaces` dan ganti eth0 nya:

```bash
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.232.1.10
    netmask 255.255.255.0
    gateway 192.232.1.1
    dns-nameservers 8.8.8.8 1.1.1.1
    up ip route add default via 192.232.1.1 dev eth0 onlink
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    post-up iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
    post-up iptables -A FORWARD -o eth0 -j ACCEPT
```

Selanjutnya buat file script untuk soal 1 (soal1.sh) yang berisikan:

```bash
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
```

Kalau sudah, jalankan dengan memberi izin eksekusi pada file.
Kemudian lakukan uji coba dengan `ping -c 3 8.8.8.8`.
