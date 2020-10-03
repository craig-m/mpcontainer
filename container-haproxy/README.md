# haproxy Readme

Haproxy notes

* https://www.haproxy.org/download/2.2/doc/configuration.txt

## notes

encrypt a password for haproxy ht auth:

```shell
printf "leftthedefault" | mkpasswd --stdin --method=sha-512
```

note: the `whois` package in apt makes mkpasswd available.

### lua scripts

haproxy embeds a lua scripting language, with it you can modify haproxy.

notes:

* https://www.haproxy.com/blog/5-ways-to-extend-haproxy-with-lua/
* https://github.com/haproxytech/haproxy-lua-acme
* https://www.arpalert.org/haproxy-lua.html
* https://github.com/haproxytech/haproxy-lua-http

### haproxy API

Control haproxy via API, connect to the haproxy container.

Issue commands:

```shell
echo "help" | nc local:/tmp/hapee-lb.sock
```

This will let us add/remove hosts on backend servers.

notes:

* https://www.haproxy.com/blog/dynamic-scaling-for-microservices-with-runtime-api/

TODO: have Kubernetes call a script, to interact with haproxy api, that can manage the pool of backend servers as containers scale out.