# MPContainer

Music Player Container 🔊 - A streaming Jukebox setup built around MPD.

Moving the CLI programs I like, and refuse to give up, into the modern world of browsers and containers. For learning and fun, not profit.

See screenshots of the [front](docs/screenshot_pub.png) and [admin](docs/screenshot_admin.png) web interfaces.

## build status

![linting](https://github.com/craig-m/mpcontainer/workflows/linting/badge.svg) ![security-scans](https://github.com/craig-m/mpcontainer/workflows/security-scans/badge.svg) ![CodeQL](https://github.com/craig-m/mpcontainer/workflows/CodeQL/badge.svg) ![docker-hub-release](https://github.com/craig-m/mpcontainer/workflows/docker-hub-release/badge.svg)

Thanks to Github [Actions](https://github.com/actions) each time this repo changes the images in the registry are updated too.

 ![build-container-mpd](https://github.com/craig-m/mpcontainer/workflows/build-container-mpd/badge.svg)
 
 ![build-container-hpx](https://github.com/craig-m/mpcontainer/workflows/build-container-hpx/badge.svg)
 
 ![build-container-web](https://github.com/craig-m/mpcontainer/workflows/build-container-web/badge.svg)
 
 ![build-container-shell](https://github.com/craig-m/mpcontainer/workflows/build-container-shell/badge.svg)
 
 ![build-containers-pyapp](https://github.com/craig-m/mpcontainer/workflows/build-containers-pyapp/badge.svg)

## App Architecture

![mpcontainer.mermaid](https://raw.githubusercontent.com/craig-m/mpcontainer/master/docs/mpcontainer-mermaid.png)

### containers

What runs in each of the 5 different container types.

#### 📦 mpd

[Music Player Daemon](https://www.musicpd.org/) is a music server that can be controlled with a client over an API ([mpc protocol](https://www.musicpd.org/doc/html/protocol.html)). Can output vorbis audio stream over http.

#### 📦 haproxy

[haproxy](https://www.haproxy.org/) is the frontend proxy, handle L7 redirects to backend services.

#### 📦 Nginx

[nginx](https://www.nginx.com/) web server is used for hosting static files. Hosts [bootstrap](https://getbootstrap.com/) + [jquery](https://jquery.com/) frameworks (installed with npm). This is the default haproxy backend.

A Multi-stage build is done, npm is not included in the final image.

#### 📦 admin-shell

[ttyd](https://tsl0922.github.io/ttyd/) lets you run a terminal in your browser. From [tmux](https://github.com/tmux/tmux) (a terminal multiplexer) you can use [ncmpcpp](https://rybczak.net/ncmpcpp/) (an ncurses MPD client app) to control the MPD server.

Access to this should be restricted on public deployments, don't put this on the open internet without changing the password variables. This web shell is for trusted users only so they can control the music.

#### 📦 Python-App

A [python](https://www.python.org/) [flask](https://flask.palletsprojects.com/en/1.1.x/) web app, run from [Gunicorn](https://gunicorn.org/).

Connects to the MPD api (with a read only user) to get stream and other dynamic information about MPD.

---

## Use

On MacOS or Windows [Docker Desktop](https://www.docker.com/products/docker-desktop) makes for a nice container experience, especially with [VSCode](https://code.visualstudio.com/) (get the [Docker](https://code.visualstudio.com/docs/containers/overview), yaml and kubernetes extensions).

Put some music into `.\music\db\` so you can use the Jukebox, these files will be exluded from Git.

### docker-compose

Deploy MPContainer in prod, or work in dev.

#### production

Start the system with images on docker hub:

```shell
docker-compose -f docker-compose.yml up -d
```

#### development

If you're deving and want to mount config files from the repo and expose ports etc:

```shell
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up --build
```

Or for a contained local Dev environment there is a VM managed by Vagrant [here](vagrant-dev-vm/README.md)

### check on it

Check on everything:

```shell
docker-compose ps
docker-compose top
```

By default MPContainer is available on port 3000 of your local interface.

The admin shell is password protected, and the `HAPX_US_USER` & `HAPX_US_PASS` can be set to override the defaults (set in docker-compose and haproxy.conf).

## manually build images

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

For steps to run in Kubernetes see this [README](kubernetes/README.md)
