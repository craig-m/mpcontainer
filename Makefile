#
# MPContainer makefile
#

huburl=docker.pkg.github.com/${GIT_UN}/mpcontainer

saveimg:
	docker save mpcontainer-mpd > /opt/mpcontainer/images/mpcontainer-mpd.tar
	docker save mpcontainer-shell > /opt/mpcontainer/images/mpcontainer-shell.tar
	docker save mpcontainer-web > /opt/mpcontainer/images/mpcontainer-web.tar
	docker save mpcontainer-frontend > /opt/mpcontainer/images/mpcontainer-frontend.tar
	docker save mpcontainer-pyapp > /opt/mpcontainer/images/mpcontainer-pyapp.tar

build:
	docker build -t ${huburl}/mpcontainer-mpd:latest -f container-mpd/Dockerfile ./container-mpd/
	docker build -t ${huburl}/mpcontainer-shell:latest -f container-shell/Dockerfile ./container-shell/
	docker build -t ${huburl}/mpcontainer-web:latest -f container-web/Dockerfile ./container-web/
	docker build -t ${huburl}/mpcontainer-pyapp:latest -f container-pyapp/Dockerfile ./container-pyapp/
	docker build -t ${huburl}/mpcontainer-frontend:latest -f container-haproxy/Dockerfile ./container-haproxy/

publish:
	docker push ${huburl}/mpcontainer-mpd:latest
	docker push ${huburl}/mpcontainer-shell:latest
	docker push ${huburl}/mpcontainer-web:latest
	docker push ${huburl}/mpcontainer-pyapp:latest
	docker push ${huburl}/mpcontainer-frontend:latest
