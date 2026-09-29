# Langkah-Langkah

Setelah memastikan BIND9 sudah terpasang di `prab` dan `tedd`, cek file konfigurasi lokal BIND9 di `prab`. 
Pastikan `tedd` telah diberi izin untuk zone transfer. 

Jalankan:
```bash
dig @192.232.3.7 k42.com soa # Pada PRAB
dig @192.232.3.6 k42.com soa # Pada TEDD
```

![image](../assets/6_dig-prab.png)
![alt text](../assets/6_dig-tedd.png)

Dari hasil pengecekan tersebut, dapat dilihat bahwa nilai serial SOA dari `tedd` dan `prab` adalah sama, yakni dengan nilai `2024100202`.