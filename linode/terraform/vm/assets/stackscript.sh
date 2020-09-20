#!/bin/bash

# MPContainer StackScript
# https://github.com/craig-m/mpcontainer

#
# input vars:
#

# <UDF name="uuidvar" default="aabbccdd-eeff-0011-2233-445566778899" label="uuidvar" example="uuid" />
# <UDF name="adduser" default="sysadmin" label="non-root admin user for vm" example="sysadmin" />
# <UDF name="userpass" default="password" label="non-root admin user for vm" example="password" />

#
# setup env
#

set -o verbose

logit() {
    printf "$1 \\n";
    logger "stackscript: $1";
}

logit "starting deployment"

if [ ! -d /root/log/ ]; then
    mkdir -v /root/log/;
    touch -f /root/log/ctf.txt
    echo ${UUIDVAR} > /root/log/ctf.txt
else
    logit "stackscript has already run";
fi

# log all output from this script
exec > >(tee /root/log/stackscript.log)
exec 2>&1

ulimit -n 8192

#
# install repo software
#

logit "updating OS"

apt update
apt upgrade -y

# install minimum packages
apt install -y -q \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    tmux \
    vim \
    git \
    curl \
    rsync \
    unzip \
    make \
    expect \
    inotify-tools \
    monitoring-plugins-common \
    monitoring-plugins-basic \
    sqlite;

# install ansible
if [ ! -x "$(command -v ansible)" ]; then
    apt-add-repository --yes --update ppa:ansible/ansible
    apt install -y -q ansible
    mkdir -pv /etc/ansible/facts.d/
    logit "installed ansible"
fi

# ansible fact
cat << EOF > /etc/ansible/facts.d/mpconline.fact
#!/usr/bin/env bash
# check if mpcontainer port is open. 1 yes, 0 no.
mpcup=$(curl -6 localhost:3000 --head --silent --connect-timeout .5 | grep "x-clacks-overhead: GNU Terry Pratchett" | wc -l)
echo "{\"mpc_online\" : \"${mpcup}\"}"
EOF
chmod 0755 /etc/ansible/facts.d/mpconline.fact

#
# env setup
#

state_db_file="/opt/linode_vm/sys_state.sqlite"

if [ ! -d /opt/linode_vm/ ]; then
    mkdir -v --mode=0755 /opt/linode_vm/
fi

# sqlite db
if [ ! -x "$(command -v sqlite3)" ]; then
    logit "missing sqlite3";
    exit 1;
fi
if [ ! -f "${state_db_file}" ]; then
    echo "creating ${state_db_file} database";
sqlite3 "${state_db_file}" <<END_SQL
CREATE TABLE sysstate ( name varchar(20), state varchar(10) );
INSERT INTO sysstate VALUES ('sqlite_int', 'true');
END_SQL
    ls -la ${state_db_file}
    logit "created ${state_db_file}";
fi

# log all packages, and versions, at creation time
if [ ! -f /root/log/packages.txt ]; then
    touch /root/log/packages.txt
    date >> /root/log/packages.txt
    apt list --installed >> /root/log/packages.txt
    echo "--- EOF ---" >> /root/log/packages.txt
    chattr +i /root/log/packages.txt
fi

# log sshd fingerprints 
if [ ! -f /opt/linode_vm/ssh_keys.txt ]; then
    touch /opt/linode_vm/ssh_keys.txt
    ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key >> /opt/linode_vm/ssh_keys.txt
    ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key >> /opt/linode_vm/ssh_keys.txt
fi

#
# stackscript opts
#

# add a non-root user
user_state=$(sqlite3 "${state_db_file}" "SELECT state from sysstate where name='user_state';")
if [[ "${user_state}" = "true" ]]; then
    logit "user already exists"
else
    adduser ${ADDUSER} --disabled-password --gecos ""
    echo "$ADDUSER:$USERPASS" | chpasswd
    mkdir -pv --mode=700 /home/${ADDUSER}/.ssh/
    touch -f /home/${ADDUSER}/.ssh/authorized_keys
    chmod 600 /home/${ADDUSER}/.ssh/authorized_keys
    chown -R ${ADDUSER}:${ADDUSER} /home/${ADDUSER}/
    getent passwd $ADDUSER && \
        sqlite3 "${state_db_file}" "INSERT INTO sysstate VALUES ('user_state', 'true');"
    logit "created user"
fi

#
# docker
#

docker_inst=$(sqlite3 "${state_db_file}" "SELECT state from sysstate where name='docker_inst';")
if [[ "${docker_inst}" = "true" ]]; then
    logit "docker already installed"
else
    # add docker
    logit "setup docker repo"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    apt-key fingerprint 0EBFCD88 || exit 1
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt update
    apt install -y -q docker-ce docker-ce-cli containerd.io
    # add docker compose
    curl -L "https://github.com/docker/compose/releases/download/1.27.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    # test
    logit "test docker"
    docker run hello-world && \
        sqlite3 "${state_db_file}" "INSERT INTO sysstate VALUES ('docker_inst', 'true');" || exit 1
    logit "docker install finished"
fi

#
# mpcontainer app
#

# get source code
git_clone=$(sqlite3 "${state_db_file}" "SELECT state from sysstate where name='git_clone';")
if [[ "${git_clone}" = "true" ]]; then
    logit "have code already"
else
    git -C /opt/linode_vm/ clone https://github.com/craig-m/mpcontainer.git && \
    qlite3 "${state_db_file}" "INSERT INTO sysstate VALUES ('git_clone', 'true');"
    logit "checked out code"
fi

#
# done
#

stacks_fin=$(sqlite3 "${state_db_file}" "SELECT state from sysstate where name='stacks_fin';")
if [[ "${stacks_fin}" = "true" ]]; then
    logit "stackscript finished (again)"
else
    sqlite3 "${state_db_file}" "INSERT INTO sysstate VALUES ('stacks_fin', 'true');"
    logit "stackscript finished"
fi

# eof