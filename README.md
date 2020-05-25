MPContainer
-----------

Music Player Container - A streaming Jukebox setup.

Moving the programs I like, and refuse to give up, into the modern world of browsers and containers. For learning and fun, not profit.


# Stack

mpcontainer is made from:

* [MPD](https://www.musicpd.org/) - music server
* [ncmpcpp](https://rybczak.net/ncmpcpp/) - an ncurses MPC client
* [ttyd](https://tsl0922.github.io/ttyd/) - share your terminal over the web
* [tmux](https://github.com/tmux/tmux) - terminal multiplexer
* [haproxy](https://www.haproxy.org/) - frontend proxy
* [nginx](https://www.nginx.com/) - web server for staic files
* [bootstrap](https://getbootstrap.com/) - CSS framework


An ASCII art diagram of the 4 container compose setup:

```
           ┌───────[ Browser ]                                         
           V                                                           
     +-------------+        +-------------+                            
     |  HA Proxy   |───────>|  NGINX web  |===(volume)===[ ./webfiles ]
     +-------------+ (http) +-------------+                            
           │   │                                                       
     (http)│   │                                                       
           │   └────(audio)────────┐                                   
           V                       V                                   
     +-------------+        +-------------+                            
     | Admin shell |───────>| MPD server  |===(volume)===[ ./music/db ]
     +-------------+ (mpc)  +-------------+                            
```


## Use

On MacOS or Windows [Docker Desktop](https://www.docker.com/products/docker-desktop) makes for a nice container experience, especially with [VSCode](https://code.visualstudio.com/).


Start the system:

```
docker-compose -f "docker-compose.yml" up -d --build
```

Build Images:

```
docker login
export mpc_dock_repo="< my docker repo name >"
make build
```


Kubernetes
----------

_K8 is a work In Progress. Thanks to [0x646e78](https://github.com/0x646e78) for most of the commits here_


This currently supports mounting a music directory from an NFS share. Your cluster will probably need 'nfs-common' (deb) or 'nfs-utils' (rh) installed.


### Ingress Controller.

Your cluster needs to have an Ingress Controller running. You can add an NGINX controller via:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
```

You can get the port the ingress controller runs on from:

```
kubectl -n ingress-nginx get svc
```


### Run

Set the NFS server and path details:

```
cp kubernetes/examples/pv.yaml.example kubernetes/pv.yaml
vi kubernetes/pv.yaml
```

Apply the manifests

```
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f ./kubernetes/
```

Check on it:

```
kubectl -n musicplayer get deployments,pods,svc,ep
```


### Pulling from a private registry

If you're pulling from a private registry, give the namespace a secret.

1) Login via `docker login` or paste into `~/.docker/config.json`

2) Create a secret in the namespace:

```
kubectl -n musicplayer create secret generic regcred \
    --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```
