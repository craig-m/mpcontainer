# MPContainer

Music Player Container - A streaming Jukebox setup.

Moving the programs I like, and refuse to give up, into the modern world of browsers and containers. For learning and fun, not profit.

![build containers](https://github.com/craig-m/mpcontainer/workflows/build%20containers/badge.svg)
![linting actions](https://github.com/craig-m/mpcontainer/workflows/linting%20actions/badge.svg)

## App Architecture

An ASCII art diagram:

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
  | Admin shell |───────>| MPD server  |=====[ music files ]  
  +-------------+ (mpc)  +-------------+                      
```

Currently 5 different images are used.

### containers

What each of the images above contains:

#### 📦 mpd

[Music Player Daemon](https://www.musicpd.org/) is a music server that can be controlled with a (mpc) client. Can output vorbis audio stream over http.

#### 📦 haproxy

[haproxy](https://www.haproxy.org/) is the frontend proxy, do L7 redirects to backends.

#### 📦 Nginx

[nginx](https://www.nginx.com/) web server is used for hosting static files. Hosts [bootstrap](https://getbootstrap.com/) + [jquery](https://jquery.com/) frameworks (installed with npm). This is the default haproxy backend.

A Multi-stage build is done, npm is not included in the final image.

#### 📦 admin-shell

[ttyd](https://tsl0922.github.io/ttyd/) lets you run a terminal in your browser. From [tmux](https://github.com/tmux/tmux) (a terminal multiplexer) you can use [ncmpcpp](https://rybczak.net/ncmpcpp/) (an ncurses MPC client) to control the MPD server.

Access to this should be restricted on public deployments, this security is left to the user (don't just put this on the open internet). This web shell is for trusted users only.

#### 📦 Python-App

A [python](https://www.python.org/) [flask](https://flask.palletsprojects.com/en/1.1.x/) web app, run from [Gunicorn](https://gunicorn.org/).

To talk to the MPD container (with a read only user), and provide other dynamic information.

### future dev plans

Planning to do some of the following.

* use [liquidsoap](https://www.liquidsoap.info/) containers for High availability, and to add some radio station logic etc. Use stream silence detection to swap between MPD servers.
* feed MPD audio stream/s to a pool of [Icecast](https://icecast.org/) containers so we can scale out for more listeners.
* secondary MPD container for alternate stream.

## Use

On MacOS or Windows [Docker Desktop](https://www.docker.com/products/docker-desktop) makes for a nice container experience, especially with [VSCode](https://code.visualstudio.com/) (get the Docker, yaml and kubernetes extensions).

Put some music into `.\music\db\` so you can use the Jukebox.

### docker-compose

build containers and start system:

```shell
docker-compose -f "docker-compose.yml" up -d --build
```

check on everything:

```shell
docker-compose ps
docker-compose top
```

---

## Kubernetes

Deploying MPContainer to [Kubernetes](https://kubernetes.io/) is a work in progress.

Thanks to [0x646e78](https://github.com/0x646e78) for most of the initial commits here.

### build images

Images, along with this code, are hosted thanks to Github.

Create a Personal Access Token ([pat](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)) for git, then add create environment vars for this and your username.

```
export GIT_TOKE="xxxxx"
export GIT_UN="<git username>"
```

login to registry:

```
docker login https://docker.pkg.github.com -u $GIT_UN --password $GIT_TOKE
```

Build and push Images:

```shell
make build
make publish
```

### Music Volume

We need to have some config that will point to where the music is.

Copy the yaml config files you need for your environment into the kubernetes dir, make sure the files are prefixed with `pv-` so they will be ignored by Git.

```shell
cp kubernetes/examples/pv-claim.yaml kubernetes/pv-claim.yaml
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

### Ingress

to do (for [linode](https://www.linode.com/products/kubernetes/)).

## private registry

If you're pulling from a [private registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/), give the namespace a secret.

1) Login via `docker login` or paste into `~/.docker/config.json`

2) Create a secret in the namespace:

```shell
kubectl -n musicplayer create secret generic regcred \
    --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```
