# HAProxy L7 frontend
# https://hub.docker.com/_/haproxy

FROM haproxy:2.2-alpine
EXPOSE 3000/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.1"
LABEL mpcontainer.service="haproxy frontend gateway"

RUN mkdir /usr/local/bin/lua

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY lua/*.lua /usr/local/bin/lua/
COPY checkhap.sh /usr/local/bin/checkhap.sh

RUN chmod 644 /usr/local/etc/haproxy/haproxy.cfg && \
    chown root:root /usr/local/etc/haproxy/haproxy.cfg /usr/local/bin/checkhap.sh && \
    chmod 755 /usr/local/bin/checkhap.sh && \
    chmod 644 /usr/local/bin/lua/*.lua && \
    chown root:root /usr/local/bin/lua/*.lua 

ARG haproxy_user_pass=leftthedefault1
ENV HAPX_US_PASS=$haproxy_user_pass

USER nobody
