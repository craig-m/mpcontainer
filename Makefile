build:
	docker build -t ectoplasm/mpcontainer-mpd:latest -f dockerfile-mpd .
	docker build -t ectoplasm/mpcontainer-shell:latest -f dockerfile-shell .
	docker build -t ectoplasm/mpcontainer-web:latest -f dockerfile-web .

publish:
	docker push ectoplasm/mpcontainer-mpd:latest
	docker push ectoplasm/mpcontainer-shell:latest
	docker push ectoplasm/mpcontainer-web:latest
