#
# MPContainer makefile
# https://www.gnu.org/software/make/manual/make.html
#

regurl=docker.pkg.github.com/${GIT_UN}/mpcontainer
#regurl=localhost:5000

dev:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d

logs:
	docker-compose -f docker-compose.yml -f docker-compose-dev.yml logs --tail="all"

reg:
	docker run -d -p 5000:5000 --restart always --name registry registry:2

build:
	docker build -t ${regurl}/mpcontainer-mpd:latest -f src/mpd/Dockerfile ./src/mpd/
	docker build -t ${regurl}/mpcontainer-shell:latest -f src/adminshell/Dockerfile ./src/adminshell/
	docker build -t ${regurl}/mpcontainer-web:latest -f src/web/Dockerfile ./src/web/
	docker build -t ${regurl}/mpcontainer-pyapp:latest -f src/pyapp/Dockerfile ./src/pyapp/
	docker build -t ${regurl}/mpcontainer-frontend:latest -f src/haproxy/Dockerfile ./src/haproxy/

publish:
	docker push ${regurl}/mpcontainer-mpd:latest
	docker push ${regurl}/mpcontainer-shell:latest
	docker push ${regurl}/mpcontainer-web:latest
	docker push ${regurl}/mpcontainer-pyapp:latest
	docker push ${regurl}/mpcontainer-frontend:latest

saveimg:
	docker save mpcontainer-mpd > /opt/mpcontainer/images/mpcontainer-mpd.tar
	docker save mpcontainer-shell > /opt/mpcontainer/images/mpcontainer-shell.tar
	docker save mpcontainer-web > /opt/mpcontainer/images/mpcontainer-web.tar
	docker save mpcontainer-frontend > /opt/mpcontainer/images/mpcontainer-frontend.tar
	docker save mpcontainer-pyapp > /opt/mpcontainer/images/mpcontainer-pyapp.tar