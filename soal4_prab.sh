# Bagian 1
echo 'options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    allow-query { any; };
    dnssec-validation no;
    listen-on-v6 { any; };
};' > /etc/bind/named.conf.options

# Bagian 2
echo 'zone "k42.com" {
    type master;
    notify yes;
    also-notify { 192.232.3.6; };
    allow-transfer { 192.232.3.6; };
    file "/etc/bind/jarkom/k42.com";
};' > /etc/bind/named.conf.local


# Bagian 3
mkdir -p /etc/bind/jarkom

echo '
;
; BIND data file for k42.com
;
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
@       IN      A       192.232.2.2     ; penny (gerbang aplikasi dinamis)
prab    IN      A       192.232.3.7
tedd    IN      A       192.232.3.6' > /etc/bind/jarkom/k42.com