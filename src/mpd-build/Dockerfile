# MusicPlayerDaemon (MPD) build container

FROM debian:testing
EXPOSE 6600/tcp 3123/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="2.5"
LABEL mpcontainer.service="MPD Build env"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
  apt-get -y install \
  bash less dos2unix net-tools iproute2 gpg vim git bash-completion \
  build-essential meson g++ gdb xxd hexcurse \
  libpcre3-dev \
  libmad0-dev libmpg123-dev libid3tag0-dev \
  libflac-dev libvorbis-dev libopus-dev libogg-dev \
  libadplug-dev libaudiofile-dev libsndfile1-dev libfaad-dev \
  libfluidsynth-dev libgme-dev libmikmod-dev libmodplug-dev \
  libmpcdec-dev libwavpack-dev libwildmidi-dev \
  libsidplay2-dev libsidutils-dev libresid-builder-dev \
  libavcodec-dev libavformat-dev \
  libmp3lame-dev libtwolame-dev libshine-dev \
  libsamplerate0-dev libsoxr-dev \
  libbz2-dev libcdio-paranoia-dev libiso9660-dev libmms-dev \
  libzzip-dev \
  libgstreamer1.0-dev \
  libcurl4-gnutls-dev libyajl-dev libexpat-dev \
  libasound2-dev libao-dev libopenal-dev \
  libpulse-dev libshout3-dev \
  libsndio-dev \
  libmpdclient-dev \
  libsqlite3-dev \
  libsystemd-dev \
  libgtest-dev \
  libboost-dev \
  libicu-dev \
  libchromaprint-dev \
  libgcrypt20-dev \
  libfmt-dev fmtools dictfmt binfmtc;

# MPD deps we do not need (keep removing from above):
#
# libnfs-dev libsmbclient-dev libupnp-dev libavahi-client-dev
# libjack-jackd2-dev


RUN groupadd --system builder && \
    useradd --system --gid builder --home-dir /code --shell /bin/bash \
    --comment "mpcontainer compile env" builder

RUN mkdir /etc/mpd && \
  mkdir -p /var/lib/mpd/ && \
  chown builder:builder /var/lib/mpd/ && \
  mkdir -p /var/log/mpd && \
  mkdir -pv /code && \
  chown builder:builder -R /code

COPY ./src/build.sh /code/build.sh

USER builder
WORKDIR /code

CMD ["bash"]
