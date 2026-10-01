#!/bin/bash

echo "=== 1. Cek Sinkronisasi Serial SOA di Tedd ==="
dig k42.com SOA @127.0.0.1 +short
echo ""

echo "=== 2. Verifikasi TXT Record Klien dari Tedd ==="
for client in alpha beta gamma delta epsilon; do
    echo -n "Query TXT ${client}.k42.com: "
    dig TXT ${client}.k42.com @127.0.0.1 +short
done