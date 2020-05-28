#
# optional:
#    export mpc_dock_repo="xxxx/"
#

saveimg:
	docker save mpcontainer-mpd > /opt/mpcontainer/images/mpcontainer-mpd.tar
	docker save mpcontainer-shell > /opt/mpcontainer/images/mpcontainer-shell.tar
	docker save mpcontainer-web > /opt/mpcontainer/images/mpcontainer-web.tar

build:
	docker build -t ${mpc_dock_repo}mpcontainer-mpd:latest -f dockerfile-mpd .
	docker build -t ${mpc_dock_repo}mpcontainer-shell:latest -f dockerfile-shell .
	docker build -t ${mpc_dock_repo}mpcontainer-web:latest -f dockerfile-web .

publish:
	docker push ${mpc_dock_repo}mpcontainer-mpd:latest
	docker push ${mpc_dock_repo}mpcontainer-shell:latest
	docker push ${mpc_dock_repo}mpcontainer-web:latest
