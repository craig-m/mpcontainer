# MPContainer static backend web server

#----------------------------------------
# Build container

# https://hub.docker.com/_/node/
FROM node:14.17.3-alpine3.13

ARG builddate
LABEL mpcontainer.builddate=$builddate

WORKDIR /home/node/app
COPY ./package.json* /home/node/app/
RUN chown -R node:node /home/node/

ENV TZ=Etc/UTC

USER node
RUN npm install
#----------------------------------------

# https://hub.docker.com/_/nginx
FROM nginx:1.21.1-alpine

ARG builddate
LABEL mpcontainer.builddate=$builddate

EXPOSE 8880/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL mpcontainer.description="Static web server"
LABEL mpcontainer.version="2.6.4"

HEALTHCHECK --timeout=10s CMD /usr/bin/curl --silent --show-error --fail http://localhost:8880/ping/stat > /dev/null

COPY --chown=root:root nginx.conf /etc/nginx/nginx.conf

RUN chmod 644 /etc/nginx/nginx.conf && \
    mkdir -pv /var/cache/nginx/client_temp && \
    chmod 600 /var/cache/nginx/client_temp && \
    mkdir -pv /var/cache/nginx/proxy_temp && \
    chmod 600 /var/cache/nginx/proxy_temp && \
    chown nginx:root /var/cache/nginx/client_temp && \
    chown nginx:root /var/run && \
    chmod 775 /var/run && \
    chmod -R 777 /tmp

COPY ./html/ /usr/share/nginx/html/

# copy files from build container (not the right way to do this :])
COPY --from=0 /home/node/app/node_modules/ /usr/share/nginx/node_modules/

# webserver file perms
RUN find /usr/share/nginx/ -type d -exec chmod 775 {} \;
RUN find /usr/share/nginx/ -type f -exec chmod 644 {} \;
RUN chown root:root /usr/share/nginx/*

WORKDIR /usr/share/nginx/

USER nginx