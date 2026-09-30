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
    type slave;
    masters { 192.232.3.7; };
    file "/var/lib/bind/k42.com";
};' > /etc/bind/named.conf.local