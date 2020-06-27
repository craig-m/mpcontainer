FROM debian:buster-slim

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="MPD Build env"

RUN apt-get update && \
  apt-get -y install \
  bash less dos2unix net-tools iproute2 gpg vim tmux git python3-pip curl && \
  pip3 install linode-cli --upgrade;

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
  chmod +x ./kubectl && \
  mv ./kubectl /usr/local/bin/kubectl;

RUN groupadd --system sysadmin && \
    useradd --system --gid sysadmin --home-dir /code --shell /bin/bash \
    --comment "mpcontainer compile env" sysadmin

RUN mkdir -pv /code && \
  chown sysadmin:sysadmin -R /code

USER sysadmin
WORKDIR /code

CMD ["bash"]
