# MusicPlayerDaemon (MPD) server container
# https://www.musicpd.org/

FROM debian:buster-slim
EXPOSE 6600/tcp 3123/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="MPD stream server"

RUN apt-get update && \
  apt-get -y install --no-install-recommends \
  bash less dos2unix net-tools iproute2 gpg mpd mpc && \
  apt-get clean

COPY mpd.conf /etc/mpd.conf

RUN chown root:root /etc/mpd.conf && \
  chmod 644 /etc/mpd.conf && \
  touch /var/lib/mpd/state && \
  chmod 644 /var/lib/mpd/state && \
  chown mpd:audio /var/lib/mpd/state

USER mpd
WORKDIR /var/lib/mpd/

CMD ["mpd", "--no-daemon", "--stdout", "/etc/mpd.conf"]
