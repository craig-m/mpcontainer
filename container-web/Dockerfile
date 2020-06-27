# MPContainer web server

# https://hub.docker.com/_/node/
FROM node:14-alpine
WORKDIR /home/node/app
COPY package.json* /home/node/app/
RUN chown node:node /home/node/*
USER node
RUN npm install

# https://hub.docker.com/_/nginx
FROM nginx:1.18-alpine
EXPOSE 8880/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.0"
LABEL mpcontainer.service="Web files"

COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 644 /etc/nginx/nginx.conf && \
    chown root:root /etc/nginx/nginx.conf && \
    mkdir -pv /var/cache/nginx/client_temp && \
    chmod 600 /var/cache/nginx/client_temp && \
    mkdir -pv /var/cache/nginx/proxy_temp && \
    chmod 600 /var/cache/nginx/proxy_temp && \
    chown nginx:root /var/cache/nginx/client_temp && \
    chown nginx:root /var/run && \
    chmod 775 /var/run

# copy files from build container
COPY --from=0 /home/node/app/node_modules/ /usr/share/nginx/node_modules/

RUN find /usr/share/nginx/html/ -type d -exec chmod 775 {} \;
RUN find /usr/share/nginx/html/ -type f -exec chmod 644 {} \;
RUN chown root:root /usr/share/nginx/html/*

USER nginx
