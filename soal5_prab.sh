# Cukup tambahkan beberapa bagian saja untuk nomor 5 ini dan ganti serial menjadi 202
echo '
;
; BIND data file for k42.com
;
$TTL    604800
@       IN      SOA     prab.k42.com. root.k42.com. (
                        2024100202      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      prab.k42.com.
@       IN      NS      tedd.k42.com.
@       IN      A       192.232.2.2     ; penny (gerbang aplikasi dinamis)
prab    IN      A       192.232.3.7
tedd    IN      A       192.232.3.6
rootkit IN      A       192.232.1.1
alpha   IN      A       192.232.5.4
beta    IN      A       192.232.5.3
gamma   IN      A       192.232.5.2
delta   IN      A       192.232.1.2
epsilon IN      A       192.232.1.3
abbey   IN      A       192.232.4.2
penny   IN      A       192.232.2.2
obladi  IN      A       192.232.3.5
desmond IN      A       192.232.3.4
oblada  IN      A       192.232.3.3
molly   IN      A       192.232.3.2' > /etc/bind/jarkom/k42.com

# Setelah itu jalankan berikut
named-checkzone k42.com /etc/bind/jarkom/k42.com
service named restart