# Python3 MPContainer PyApp

# https://hub.docker.com/_/python
FROM python:3.9.7-slim-buster

EXPOSE 8888/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL mpcontainer.name="mpcontainer-pyapp"
LABEL mpcontainer.description="mpc python3 flask app"
LABEL mpcontainer.version="2.6.4"

ENV TZ=Etc/UTC

HEALTHCHECK CMD /usr/local/bin/python /pyapp/healthcheck-pid.py

RUN groupadd --system pyapp && \
    useradd --system --gid pyapp --home-dir /app --shell /sbin/nologin \
    --comment "mpcontainer pyapp" pyapp && \
    mkdir /pyapp

ENV HOME=/pyapp
COPY --chown=root:pyapp src/* /pyapp/
COPY --chown=root:root docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /pyapp

RUN chmod +x /docker-entrypoint.sh && chmod 770 /pyapp;
RUN find /pyapp -type d -exec chmod 775 {} \;
RUN find /pyapp -type f -exec chmod 644 {} \;

# install app requirements
RUN pip install -r /pyapp/requirements.txt

USER pyapp

# Run in Dev mode? (default False)
ARG mpcpyapp_dev=false
ENV env_mpcpyapp_dev=$mpcpyapp_dev

# return on http:// ip /host/env/
ARG mpypyapp_envtest=default_0
ENV env_mpypyapp_envtest=$mpypyapp_envtest

ENTRYPOINT ["/docker-entrypoint.sh"]