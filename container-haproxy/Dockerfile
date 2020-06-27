# HAProxy L7 frontend
# https://hub.docker.com/_/haproxy

FROM haproxy:2.1-alpine
EXPOSE 3000/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="haproxy frontend gateway"

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN chmod 644 /usr/local/etc/haproxy/haproxy.cfg && \
    chown root:root /usr/local/etc/haproxy/haproxy.cfg

USER nobody
