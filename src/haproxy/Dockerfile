# HAProxy L7 frontend

# https://hub.docker.com/_/haproxy
FROM haproxy:2.4.4-alpine

EXPOSE 3000/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL mpcontainer.name="mpcontainer-frontend"
LABEL mpcontainer.description="haproxy frontend gateway"
LABEL mpcontainer.version="2.6.4"

ENV TZ=Etc/UTC

HEALTHCHECK CMD /bin/sh /usr/local/bin/checkhap.sh

COPY --chown=root:root haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY --chown=root:root lua/*.lua /usr/local/bin/lua/
COPY --chown=root:root checkhap.sh /usr/local/bin/checkhap.sh

ARG haproxy_user_pass=leftthedefault1
ENV HAPX_US_PASS=$haproxy_user_pass

USER haproxy