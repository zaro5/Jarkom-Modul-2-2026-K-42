#!/bin/bash

# Buat direktori admin dan file index.html
mkdir -p /var/www/html/admin
echo "<h1>Dokumen Rahasia Sindikat</h1>" > /var/www/html/admin/index.html

echo "Setup folder /admin di backend selesai!"