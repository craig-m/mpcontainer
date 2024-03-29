# MPContainer admin shell

# https://hub.docker.com/r/tsl0922/ttyd
FROM tsl0922/ttyd

EXPOSE 7681/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL mpcontainer.name="mpcontainer-shell"
LABEL mpcontainer.description="ttyd DJ web shell"
LABEL mpcontainer.version="2.6.4"

ENV TERM=xterm-256color
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

HEALTHCHECK CMD /usr/bin/pgrep ttyd

RUN apt update && \
    apt-get install -y --no-install-recommends tmux vim ncmpcpp mpc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# create a non-root user
RUN groupadd -r dj && \
    useradd -r -g dj -d /home/dj -s /bin/bash -c "dj" dj && \
    adduser dj audio

RUN mkdir -pv /home/dj/.ncmpcpp && \
    mkdir /home/dj/scripts && \
    chmod 770 /home/dj && \
    touch /etc/profile.d/20-profile.sh && \
    echo 'export PS1="\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ "' >> /etc/profile.d/20-profile.sh

COPY --chown=root:root files/10-alias.sh /etc/profile.d/10-alias.sh
COPY files/bashrc /home/dj/.bashrc
COPY files/tmux.conf /home/dj/.tmux.conf
COPY files/ncmpcpp_config /home/dj/.ncmpcpp/config
COPY files/start-tmux.sh /home/dj/start-tmux.sh

RUN chown dj:dj -R /home/dj && \
    chmod +x /home/dj/start-tmux.sh

USER dj
WORKDIR /home/dj

 # start tini first ( https://github.com/krallin/tini )
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/ttyd", "--port", "7681", "--max-clients", "10", "--base-path", "/admin/shell", "/usr/bin/bash"]