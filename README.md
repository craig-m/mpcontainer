# MPContainer

Music Player Container 🔊 - A streaming Jukebox setup.

Moving the programs I like, and refuse to give up, into the modern world of browsers and containers. For learning and fun, not profit.

![linting](https://github.com/craig-m/mpcontainer/workflows/linting/badge.svg) ![security-scans](https://github.com/craig-m/mpcontainer/workflows/security-scans/badge.svg) ![CodeQL](https://github.com/craig-m/mpcontainer/workflows/CodeQL/badge.svg) ![docker-hub-release](https://github.com/craig-m/mpcontainer/workflows/docker-hub-release/badge.svg)

## App Architecture

![mpcontainer.mermaid](https://raw.githubusercontent.com/craig-m/mpcontainer/master/mpcontainer-mermaid.png)

### containers

What runs in each of the 5 containers that MPContainer consists of.

#### 📦 mpd

[Music Player Daemon](https://www.musicpd.org/) is a music server that can be controlled with a client over an API ([mpc protocol](https://www.musicpd.org/doc/html/protocol.html)). Can output vorbis audio stream over http.

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

Connects to the MPD api (with a read only user) to get stream and other dynamic information about MPD.

### build status

Thanks to Github [Actions](https://github.com/actions) each time this repo changes the images in the registry are updated too.

![build-container-mpd](https://github.com/craig-m/mpcontainer/workflows/build-container-mpd/badge.svg) ![build-container-hpx](https://github.com/craig-m/mpcontainer/workflows/build-container-hpx/badge.svg) ![build-container-web](https://github.com/craig-m/mpcontainer/workflows/build-container-web/badge.svg) ![build-container-shell](https://github.com/craig-m/mpcontainer/workflows/build-container-shell/badge.svg) ![build-containers-pyapp](https://github.com/craig-m/mpcontainer/workflows/build-containers-pyapp/badge.svg)

## Use

On MacOS or Windows [Docker Desktop](https://www.docker.com/products/docker-desktop) makes for a nice container experience, especially with [VSCode](https://code.visualstudio.com/) (get the [Docker](https://code.visualstudio.com/docs/containers/overview), yaml and kubernetes extensions).

Put some music into `.\music\db\` so you can use the Jukebox.

### docker-compose

Build containers and start system:

```shell
docker-compose -f docker-compose.yml up -d --build
```

If you're deving or want to mount config files from the repo:

```shell
docker-compose -f docker-compose.yml -f dev-compose.yaml up --build
```

Check on everything:

```shell
docker-compose ps
docker-compose top
```

By default MPContainer is available on port 3000 of your local interface.

The admin shell is password protected, and the `HAPX_US_PASS` & `HAPX_US_PASS` can be set to override the defaults (set in docker-compose and haproxy.conf).

## build images

For manually updating first create a Personal Access Token ([pat](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)) for git, then add create environment vars for this and your username.

```shell
export GIT_TOKE="xxxxx"
export GIT_UN="<git username>"
```

login to registry:

```shell
echo $GIT_TOKE | docker login https://ghcr.io/ -u $GIT_UN --password-stdin
```

Build and push Images:

```shell
make build
make publish
```

---

## Kubernetes

Deploying MPContainer to [Kubernetes](https://kubernetes.io/) is a work in progress. Thanks to [0x646e78](https://github.com/0x646e78) for most of the initial commits here.

[Docker Desktop](https://www.docker.com/products/docker-desktop) includes a standalone single-node Kubernetes cluster which can be used for dev work.

### Music Volume

We need to have some config that will point to where the music is.

Copy the yaml config files you need for your environment into the kubernetes dir, make sure the files are prefixed with `pv-` so they will be ignored by Git.

```shell
cp kubernetes/examples/pv-claim.yaml kubernetes/pv-claim.yaml
cp kubernetes/examples/pv-store-dev.yaml kubernetes/pv-store-dev.yaml
```

See [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) documentation for more information.

### private registry

If you're pulling from a [private registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/), give the namespace a secret.

1) Login via `docker login` or paste into `~/.docker/config.json`

2) Create a secret in the namespace:

```shell
kubectl -n musicplayer create secret generic regcred \
    --from-file=.dockerconfigjson=/home/vagrant/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
```

## Run

After copying and editing what you need from `/kubernetes/examples/` to `/kubernetes/` for the configuration of your music volume you can apply the Kubernetes manifests to bring up MPContainer:

```shell
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f ./kubernetes/
```

Check on it:

```shell
kubectl -n musicplayer get deployments,pods,svc,ep,pv
```

Access the service for testing with a command like:

```shell
kubectl -n musicplayer port-forward frontend-6bc9c5dd68-frw8g 3000:3001
```

Clean up:

```shell
kubectl -n musicplayer delete all --all
```

That's all!
