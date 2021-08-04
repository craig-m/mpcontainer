# MusicPlayerDaemon MPD container

# https://hub.docker.com/_/debian
FROM debian:bullseye-20210621-slim

EXPOSE 6600/tcp 
EXPOSE 3123/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL mpcontainer.description="MPD stream server"
LABEL mpcontainer.version="2.6.4"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

HEALTHCHECK CMD /bin/sh /opt/healthcheck.sh

# https://packages.debian.org/bullseye/sound/mpd
# https://packages.debian.org/bullseye/sound/mpc
RUN apt-get update && \
  apt-get -y install --no-install-recommends mpd=0.22.6-1+b1 mpc=0.33-1 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY --chown=root:root mpd.conf /etc/mpd.conf
COPY --chown=root:root healthcheck.sh /opt/healthcheck.sh

RUN chmod 644 /etc/mpd.conf && \
  touch /var/lib/mpd/state && \
  chmod 644 /var/lib/mpd/state && \
  chown mpd:audio /var/lib/mpd/state && \
  chmod 755 /opt/healthcheck.sh;

USER mpd

WORKDIR /var/lib/mpd/

CMD ["mpd", "--no-daemon", "--stdout", "/etc/mpd.conf"]