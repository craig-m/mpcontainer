# MPContainer

Music Player Container - A streaming Jukebox setup.

Moving the programs I like, and refuse to give up, into the modern world of browsers and containers. For learning and fun, not profit.

## Stack

MPContainer exists thanks to some of these sources:

* [MPD](https://www.musicpd.org/) - music server
* [ncmpcpp](https://rybczak.net/ncmpcpp/) - an ncurses MPC client
* [ttyd](https://tsl0922.github.io/ttyd/) - share your terminal over the web
* [tmux](https://github.com/tmux/tmux) - terminal multiplexer
* [haproxy](https://www.haproxy.org/) - frontend proxy
* [nginx](https://www.nginx.com/) - web server for staic files
* [bootstrap](https://getbootstrap.com/) - CSS framework

## Architecture

An ASCII art diagram of the 5 container setup.

```code
       ┌───────[ Browser ]                                    
       V                                                      
  +-------------+        +-------------+                      
  |  HA Proxy   |───────>|  NGINX web  |                      
  +-------------+ (http) +-------------+                      
       │   │  │                                               
       │   │  │          +-------------+                      
       │   │  └───(http)─| Python App  |                      
       │   │             +-------------+                      
 (http)│   │                      │                           
       │   └──────(audio)────┐    │(mpc)                      
       V                     V    V                           
  +-------------+        +-------------+                      
  | Admin shell |───────>| MPD server  |======[ ./music/db ]  
  +-------------+ (mpc)  +-------------+                      
```

### future dev plans

* secondary MPD container for alternate stream.
* pipe the MPD audio stream to a pool of [Icecast](https://icecast.org/) containers so we can scale out for more listeners.
* use [liquidsoap](https://www.liquidsoap.info/) containers for HA, and add some radio station logic etc.
* build container for web stuff (npm).
* fix up pyapp

## Use

On MacOS or Windows [Docker Desktop](https://www.docker.com/products/docker-desktop) makes for a nice container experience, especially with [VSCode](https://code.visualstudio.com/).

Put some music into `.\music\db\` and start the system:

```shell
docker-compose -f "docker-compose.yml" up -d --build
```

Build Images:

```shell
docker login
export mpc_dock_repo="<repo username>/"
make build
```

---

## Kubernetes

Deploying MPContainer to [Kubernetes](https://kubernetes.io/) is a work in progress. The images are on [DockerHub](https://hub.docker.com/u/crgm).

Thanks to [0x646e78](https://github.com/0x646e78) for most of the initial commits here.

### Ingress Controller

Your cluster needs to have an Ingress Controller running. You can add an NGINX controller via:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/baremetal/deploy.yaml
```

You can get the port the ingress controller runs on from:

```shell
kubectl -n ingress-nginx get svc
```

### Music Volume

We need to have some config that will point to where the music is.

Copy one of the config files into the kubernetes dir, make sure this file is prefixed with `pv-` so it will be ignored by Git.

```shell
cp kubernetes/examples/pv-dev.yaml kubernetes/pv-dev.yaml
```

See [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) documentation for more information.

### Run

After copying and editing what you need from ./kubernetes/examples/ to ./kubernetes/.

Apply the manifests to bring up MPContainer:

```shell
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f ./kubernetes/
```

Check on it:

```shell
kubectl -n musicplayer get deployments,pods,svc,ep
```

## private registry

If you're pulling from a private registry, give the namespace a secret.

1) Login via `docker login` or paste into `~/.docker/config.json`

2) Create a secret in the namespace:

```shell
kubectl -n musicplayer create secret generic regcred \
    --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```
