FROM debian:buster-slim

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="MPD SysAdmin container"

RUN apt-get update && \
  apt-get -y install \
  bash less dos2unix gnupg2 net-tools iproute2 python3-pip && \
  pip3 install linode-cli --upgrade && \
  pip3 install ansible;

COPY ansible-playbook.yml /opt/ansible-playbook.yml
RUN ansible-playbook --connection=local -i "127.0.0.1," -- /opt/ansible-playbook.yml

USER sysadmin
WORKDIR /home/sysadmin
CMD ["bash"]
