# MusicPlayerDaemon (MPD) server container
# https://hub.docker.com/_/debian

FROM debian:bullseye-20210621-slim
EXPOSE 6600/tcp 3123/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="2.6"
LABEL mpcontainer.service="MPD stream server"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

HEALTHCHECK CMD bash /opt/healthcheck.sh

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
  bash less dos2unix net-tools iproute2 gpg mpd mpc && \
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