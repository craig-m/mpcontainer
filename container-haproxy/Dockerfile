# HAProxy L7 frontend
# https://hub.docker.com/_/haproxy

FROM haproxy:2.2-alpine
EXPOSE 3000/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="haproxy frontend gateway"

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

RUN chmod 644 /usr/local/etc/haproxy/haproxy.cfg && \
    chown root:root /usr/local/etc/haproxy/haproxy.cfg

COPY *.lua /usr/local/bin/

# haproxy_user_pass is a hash for: leftthedefault
#ARG haproxy_user_pass=$6$lIK60yJG$vglYfZXJRnukmIYCgiC7DZZFZT0JKRuYAUtuZ7V5FKTY6oQObmE8VsmxqWxzwf1luPG20GPXTBBijqa9DGLmK1
#ENV HAPX_US_PASS=$haproxy_user_pass

USER nobody
