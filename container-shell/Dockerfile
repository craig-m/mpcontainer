# ttyd - Share your terminal over the web
# https://hub.docker.com/r/tsl0922/ttyd
# https://github.com/tsl0922/ttyd

FROM tsl0922/ttyd
EXPOSE 7681/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="2.0"
LABEL mpcontainer.service="ttyd DJ web shell"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt update && \
    apt-get install -y tmux vim ncmpcpp mpc \
    mc curl socat lynx mtr-tiny \
    toilet toilet-fonts && \
    apt-get clean

# create a non-root user
RUN groupadd -r dj && \
    useradd -r -g dj -d /home/dj -s /bin/bash -c "dj" dj && \
    adduser dj audio

RUN mkdir -pv /home/dj/.ncmpcpp && \
    mkdir /home/dj/scripts && \
    chmod 770 /home/dj && \
    touch /etc/profile.d/20-profile.sh && \
    echo 'export PS1="\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ "' >> /etc/profile.d/20-profile.sh

COPY files/bashrc /home/dj/.bashrc
COPY files/tmux.conf /home/dj/.tmux.conf
COPY files/ncmpcpp_config /home/dj/.ncmpcpp/config
COPY files/10-alias.sh /etc/profile.d/10-alias.sh
COPY files/start-tmux.sh /home/dj/start-tmux.sh

RUN chown dj:dj -R /home/dj && \
    chown root:root /etc/profile.d/10-alias.sh && \
    chmod +x /home/dj/start-tmux.sh

USER dj
WORKDIR /home/dj

ARG TERM=xterm-256color

# start tini first ( https://github.com/krallin/tini )
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/ttyd", "--port", "7681", "--max-clients", "10", "--base-path", "/admin/shell", "/usr/bin/bash"]