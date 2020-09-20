# ttyd - Share your terminal over the web
# https://hub.docker.com/r/tsl0922/ttyd
# https://github.com/tsl0922/ttyd

FROM tsl0922/ttyd
EXPOSE 7681/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
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
    touch /home/dj/.ncmpcpp/config && \
      echo 'mpd_host = DJp455w0rd101@backendmpd' >> /home/dj/.ncmpcpp/config && \
      echo 'mpd_port = 6600' >> /home/dj/.ncmpcpp/config && \
      echo 'mpd_connection_timeout = 10' >> /home/dj/.ncmpcpp/config && \
      echo 'external_editor = vim' >> /home/dj/.ncmpcpp/config && \
      echo 'use_console_editor = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'user_interface = alternative' >> /home/dj/.ncmpcpp/config && \
      echo 'data_fetching_delay = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'colors_enabled = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'display_bitrate = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'display_volume_level = no' >> /home/dj/.ncmpcpp/config && \
      echo 'header_visibility = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'statusbar_visibility = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'titles_visibility = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'enable_window_title = yes' >> /home/dj/.ncmpcpp/config && \
      echo 'mouse_support = yes' >> /home/dj/.ncmpcpp/config && \
    touch /home/dj/.vimrc && \
      echo 'set laststatus=2' >> /home/dj/.vimrc && \
      echo 'syntax on' >> /home/dj/.vimrc && \
      echo 'set number' >> /home/dj/.vimrc && \
    touch /home/dj/.tmux.conf && \
      echo 'set -g default-terminal "screen-256color"' >> /home/dj/.tmux.conf && \
      echo 'set -g mouse on' >> /home/dj/.tmux.conf && \
      echo 'set -g base-index 1' >> /home/dj/.tmux.conf && \
    mkdir /home/dj/scripts && \
      echo "curl backendmpd:3123 --head -v" > /home/dj/scripts/stream-status.sh && \
      chmod +x -- /home/dj/scripts/*.sh && \
    chown dj:dj -R /home/dj && \
    chmod 770 /home/dj

RUN touch /etc/profile.d/10-alias.sh && \
    echo "alias mpc='mpc --host=backendmpd --password=DJp455w0rd101'" >> /etc/profile.d/10-alias.sh && \
    touch /etc/profile.d/20-profile.sh && \
    echo 'export PS1="\[\033[01;32m\]\u\[\033[01;34m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \$ "' >> /etc/profile.d/20-profile.sh

USER dj
WORKDIR /home/dj

# start tini first ( https://github.com/krallin/tini )
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "--port", "7681", "--max-clients", "10", "--base-path", "/admin/shell", "/usr/bin/tmux", "new", "-A", "-s", "djconsole", "ncmpcpp"]
