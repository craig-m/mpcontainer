# ttyd - Share your terminal over the web
# https://hub.docker.com/r/tsl0922/ttyd
# https://github.com/tsl0922/ttyd

FROM tsl0922/ttyd
EXPOSE 7681/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="2.0"
LABEL mpcontainer.service="ttyd DJ web shell"

RUN apt update && \
    apt-get install -y tmux vim ncmpcpp mpc \
    mc curl socat lynx mtr-tiny newsbeuter \
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

COPY files/tmux.conf /home/dj/.tmux.conf
COPY files/ncmpcpp_config /home/dj/.ncmpcpp/config
COPY files/10-alias.sh /etc/profile.d/10-alias.sh

RUN chown dj:dj -R /home/dj && \
    chown root:root /etc/profile.d/10-alias.sh

USER dj
WORKDIR /home/dj

# start tini first ( https://github.com/krallin/tini )
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "--port", "7681", "--max-clients", "10", "--base-path", "/admin/shell", "/usr/bin/tmux", "new", "-A", "-s", "djconsole", "ncmpcpp"]
