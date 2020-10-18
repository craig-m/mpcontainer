# Python3 MPContainer PyApp
# https://hub.docker.com/_/python

FROM python:3.9.0-slim-buster
EXPOSE 8888/tcp

LABEL mpcontainer.vendor="MPContainer"
LABEL version="1.1"
LABEL mpcontainer.service="mpc python3 flask app"

RUN groupadd --system pyapp && \
    useradd --system --gid pyapp --home-dir /app --shell /sbin/nologin \
    --comment "mpcontainer pyapp" pyapp

ENV HOME=/pyapp
COPY . /pyapp
WORKDIR /pyapp

RUN find /pyapp -type d -exec chmod 775 {} \;
RUN find /pyapp -type f -exec chmod 644 {} \;

# install app requirements
RUN pip install -r /pyapp/requirements.txt

USER pyapp

# Run in Dev mode? (default False)
ARG mpcpyapp_dev=false
ENV env_mpcpyapp_dev=$mpcpyapp_dev

ARG mpypyapp_envtest=container_default
ENV env_mpypyapp_envtest=$mpypyapp_envtest

# entry point - launch gunicorn
CMD ["bash", "/pyapp/start.sh"]
