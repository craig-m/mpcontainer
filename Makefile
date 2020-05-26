#
# export mpc_dock_repo="xxxx"
#

build:
	docker build -t ${mpc_dock_repo}/mpcontainer-mpd:latest -f dockerfile-mpd .
	docker build -t ${mpc_dock_repo}/mpcontainer-shell:latest -f dockerfile-shell .
	docker build -t ${mpc_dock_repo}/mpcontainer-web:latest -f dockerfile-web .

publish:
	docker push ${mpc_dock_repo}/mpcontainer-mpd:latest
	docker push ${mpc_dock_repo}/mpcontainer-shell:latest
	docker push ${mpc_dock_repo}/mpcontainer-web:latest
