# haproxy Readme

Haproxy notes

* https://www.haproxy.org/download/2.2/doc/configuration.txt
* https://www.haproxy.com/blog/dynamic-scaling-for-microservices-with-runtime-api/

## notes

encrypt a password for haproxy ht auth:

```shell
printf "leftthedefault" | mkpasswd --stdin --method=sha-512
```

note: the `whois` package in apt makes mkpasswd available.

### API

Control haproxy via API, connect to the haproxy container.

Issue commands:

```shell
echo "help" | nc local:/tmp/hapee-lb.sock
```
