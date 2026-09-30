# Soal 18
"Ubah A record DNS milik abbey.xxx.com ke alamat IP yang fiktif (ubah secara random namun pastikan format IP valid). Naikkan nilai serial SOA di prab dan pastikan tedd ikut tersinkron. Tetapkan TTL sebesar 15 detik pada record yang relevan tersebut. Verifikasi momen yang terjadi pada tiga fase pencarian: sebelum perubahan terjadi (mengembalikan IP lama), saat perubahan baru saja terjadi dalam jeda 15 detik (masih IP lama karena cache), dan setelah batas waktu TTL habis (berubah ke IP fiktif yang baru)."

## Setup Prab
```
sed -i 's/^abbey .*/abbey   15  IN  A   192.232.4.2/' /etc/bind/jarkom/k42.com
sed -i 's/2024100206/2024100207/' /etc/bind/jarkom/k42.com

grep -n "abbey" /etc/bind/jarkom/k42.com
grep -A1 "Serial" /etc/bind/jarkom/k42.com
named-checkzone k42.com /etc/bind/jarkom/k42.com
service named restart
dig abbey.k42.com @127.0.0.1
```

```
root@prab:~# sed -i 's/^abbey .*/abbey   15  IN  A   192.232.4.2/' /etc/bind/jarkom/k42.com
sed -i 's/2024100206/2024100207/' /etc/bind/jarkom/k42.com

grep -n "abbey" /etc/bind/jarkom/k42.com
grep -A1 "Serial" /etc/bind/jarkom/k42.com
named-checkzone k42.com /etc/bind/jarkom/k42.com
service named restart
dig abbey.k42.com @127.0.0.1
25:abbey   15  IN  A   192.232.4.2
34:static  IN  CNAME   abbey
                        2024100208      ; Serial
                        604800          ; Refresh
zone k42.com/IN: loaded serial 2024100208
OK
Stopping domain name service...: namedwaiting for pid 327 to die
.
Starting domain name service...: named.

; <<>> DiG 9.20.29-1~deb13u1-Debian <<>> abbey.k42.com @127.0.0.1
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53895
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 3797b3a230c4e230010000006abd5e1d8fd9ec29baf3229d (good)
;; QUESTION SECTION:
;abbey.k42.com.                 IN      A

;; ANSWER SECTION:
abbey.k42.com.          15      IN      A       192.232.4.2

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Sep 30 19:08:13 UTC 2026
;; MSG SIZE  rcvd: 86
```

## Verifikasi Tedd
```
dig k42.com SOA @127.0.0.1 +short
dig abbey.k42.com @127.0.0.1
```

```
root@tedd:~# dig k42.com SOA @127.0.0.1 +short
dig abbey.k42.com @127.0.0.1
prab.k42.com. root.k42.com. 2024100208 604800 86400 2419200 604800

; <<>> DiG 9.20.29-1~deb13u1-Debian <<>> abbey.k42.com @127.0.0.1
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1395
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
; COOKIE: 091c939a68f1fffc010000006abd5e38ce80a849b08760bf (good)
;; QUESTION SECTION:
;abbey.k42.com.                 IN      A

;; ANSWER SECTION:
abbey.k42.com.          15      IN      A       203.0.113.57

;; Query time: 1 msec
;; SERVER: 127.0.0.1#53(127.0.0.1) (UDP)
;; WHEN: Wed Sep 30 19:08:40 UTC 2026
;; MSG SIZE  rcvd: 86
```

## Setup Alpha
```
apt update
apt install dnsmasq -y

echo 'server=/k42.com/192.232.3.7' > /etc/dnsmasq.d/k42.conf
service dnsmasq restart

dig abbey.k42.com @127.0.0.1 +noall +answer
```

```
root@alpha:~# apt update
apt install dnsmasq -y

echo 'server=/k42.com/192.232.3.7' > /etc/dnsmasq.d/k42.conf
service dnsmasq restart

dig abbey.k42.com @127.0.0.1 +noall +answer
Hit:1 http://deb.debian.org/debian trixie InRelease
Hit:2 http://deb.debian.org/debian trixie-updates InRelease
Hit:3 http://deb.debian.org/debian-security trixie-security InRelease
28 packages can be upgraded. Run 'apt list --upgradable' to see them.
dnsmasq is already the newest version (2.91-1+deb13u2).
Summary:
  Upgrading: 0, Installing: 0, Removing: 0, Not Upgrading: 28
Restarting DNS forwarder and DHCP server: dnsmasq.
abbey.k42.com.          15      IN      A       192.232.4.2
```