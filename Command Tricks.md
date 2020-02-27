# Certificates

View a certificate on a host

```bash
openssl s_client -connect $host:$port -servername $host
```

View a certificate including the chain on a host

```bash
openssl s_client -connect $host:$port -servername $host -showcerts
```

Save a certificate to disk

```bash
echo "QUIT" |\
openssl s_client -connect $host:$port -servername $host |\
openssl x509 -out ~/$host.pem
```
