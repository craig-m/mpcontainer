#
# optional:
#    export mpc_dock_repo="crgm/"
#

saveimg:
	docker save mpcontainer-mpd > /opt/mpcontainer/images/mpcontainer-mpd.tar
	docker save mpcontainer-shell > /opt/mpcontainer/images/mpcontainer-shell.tar
	docker save mpcontainer-web > /opt/mpcontainer/images/mpcontainer-web.tar
	docker save mpcontainer-frontend > /opt/mpcontainer/images/mpcontainer-frontend.tar
	docker save mpcontainer-pyapp > /opt/mpcontainer/images/mpcontainer-pyapp.tar

build:
	docker build -t ${mpc_dock_repo}mpcontainer-mpd:latest -f container-mpd/Dockerfile ./container-mpd/
	docker build -t ${mpc_dock_repo}mpcontainer-shell:latest -f container-shell/Dockerfile ./container-shell/
	docker build -t ${mpc_dock_repo}mpcontainer-web:latest -f container-web/Dockerfile ./container-web/
	docker build -t ${mpc_dock_repo}mpcontainer-pyapp:latest -f container-pyapp/Dockerfile ./container-pyapp/
	docker build -t ${mpc_dock_repo}mpcontainer-frontend:latest -f container-haproxy/Dockerfile ./container-haproxy/

publish:
	docker push ${mpc_dock_repo}mpcontainer-mpd:latest
	docker push ${mpc_dock_repo}mpcontainer-shell:latest
	docker push ${mpc_dock_repo}mpcontainer-web:latest
	docker push ${mpc_dock_repo}mpcontainer-pyapp:latest
	docker push ${mpc_dock_repo}mpcontainer-frontend:latest
