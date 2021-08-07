#
# MPContainer makefile (for Linux, MacOS, WSL)
# https://www.gnu.org/software/make/manual/make.html
#

#regurl=docker.pkg.github.com/${GIT_UN}/mpcontainer
regurl=localhost:5000

#
# tasks
#

dev-vm:
	cd ./vagrant-dev-vm/ && vagrant up

dev-up:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build --detach

dev-down:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml down

dev-logs:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml logs

stop:
	docker container stop $(docker ps --filter "label=mpcontainer.vendor=MPContainer" -aq)

# The Docker Registry 2.0 implementation for storing and distributing Docker images
# https://hub.docker.com/_/registry
registry:
	docker run -d -p 5000:5000 --restart always --name registry registry:2

build:
	docker build -t ${regurl}/mpcontainer-mpd:latest -f src/mpd/Dockerfile ./src/mpd/
	docker build -t ${regurl}/mpcontainer-shell:latest -f src/adminshell/Dockerfile ./src/adminshell/
	docker build -t ${regurl}/mpcontainer-web:latest --build-arg builddate=$(date +'%Y-%m-%d') -f src/web/Dockerfile ./src/web/
	docker build -t ${regurl}/mpcontainer-pyapp:latest -f src/pyapp/Dockerfile ./src/pyapp/
	docker build -t ${regurl}/mpcontainer-frontend:latest -f src/haproxy/Dockerfile ./src/haproxy/

publish:
	docker push ${regurl}/mpcontainer-mpd:latest
	docker push ${regurl}/mpcontainer-shell:latest
	docker push ${regurl}/mpcontainer-web:latest
	docker push ${regurl}/mpcontainer-pyapp:latest
	docker push ${regurl}/mpcontainer-frontend:latest

saveimg:
	docker save mpcontainer-mpd > mpcontainer-mpd.tar
	docker save mpcontainer-shell > mpcontainer-shell.tar
	docker save mpcontainer-web > mpcontainer-web.tar
	docker save mpcontainer-frontend > mpcontainer-frontend.tar
	docker save mpcontainer-pyapp > mpcontainer-pyapp.tar
