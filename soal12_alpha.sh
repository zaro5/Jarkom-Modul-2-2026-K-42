#!/bin/bash

echo "=== Skenario 1: Tanpa Kredensial ==="
curl -i http://www.k42.com/admin/
echo -e "\n----------------------------------------\n"

echo "=== Skenario 2: Dengan Password Salah ==="
curl -i -u 'prabs:salah' http://www.k42.com/admin/
echo -e "\n----------------------------------------\n"

echo "=== Skenario 3: Dengan Kredensial Benar ==="
curl -i -u 'prabs:pakar_pinter_jadi_gob***' http://www.k42.com/admin/
echo -e "\n----------------------------------------\n"

echo "=== Skenario 4: Cek Path Utama (/) Tetap Bisa Diakses Tanpa Login ==="
curl -sI http://www.k42.com/ | head -n 1