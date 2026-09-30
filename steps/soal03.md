# Soal3

Untuk menambahkan resolver 192.168.122.1 ke semua node, masukkan dengan melalui config di setiap node nya.

Contoh (delta):

```bash
auto eth0
iface eth0 inet static
        address 192.232.1.2
        netmask 255.255.255.0
        gateway 192.232.1.1
up echo 'nameserver 192.168.122.1' > /etc/resolv.conf
```

## Catatan PENTING

Untuk node `alpha`, `beta`, nameserver harus memuat IP Address yang lainnya. Agar ketika melakukan uji coba di soal-soal berikutnya bisa dijalankan dengan baik.

```bash
up echo -e 'nameserver 192.232.3.7\nnameserver 192.232.3.6\nnameserver 192.232.3.3\nnameserver 192.168.122.1' > /etc/resolv.conf
```


## Note

- Switch 1

> Rootkit: 192.232.1.1
> Delta: 192.232.1.2
> Epsilon: 192.232.1.3

- Switch 2

> Penny: 192.232.2.2

- Switch 3

> Molly: 192.232.3.2
> Oblada: 192.232.3.3
> Desmond: 192.232.3.4
> Obladi: 192.232.3.5
> Tedd: 192.232.3.6
> Prab: 192.232.3.7

- Switch 4

> Abbey: 192.232.4.2

- Switch 5

> Gamma: 192.232.5.2
> Beta: 192.232.5.3
> Alpha: 192.232.5.4
