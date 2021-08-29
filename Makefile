#
# MPContainer makefile (for Linux, MacOS, WSL)
# https://www.gnu.org/software/make/manual/make.html
#

#
# vars
#

#regurl=docker.pkg.github.com/${GIT_UN}/mpcontainer
regurl=localhost:5000

#
# tasks
#

.PHONY: help build publish prune stop-all dev-reg dev-logs dev-down dev-up dev-vm

help:
	@echo ""
	@echo "--== MPContainer Makefile help ==--"
	@echo ""
	@echo "make dev-vm \t\t- starts vagrant vm"
	@echo "make comp-up \t\t- start compose"
	@echo "make comp-down \t\t- stop compose"
	@echo "make comp-logs \t\t- show compose logs"
	@echo "make stop-all \t\t- stop all containers by MPContainer tag"
	@echo "make dev-reg \t\t- start registry container"
	@echo ""

.DEFAULT_GOAL := help


dev-vm:
	cd ./vagrant-dev-vm/ && vagrant up

comp-up:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build --detach
	docker ps

comp-down:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml down

comp-logs:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml logs

stop-all:
	docker container stop $(docker ps --filter "label=mpcontainer.vendor=MPContainer" -aq)

# The Docker Registry 2.0 implementation for storing and distributing Docker images
# https://hub.docker.com/_/registry
dev-reg:
	docker run -d -p 5000:5000 --restart always --name registry registry:2

prune:
	docker system prune -af

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