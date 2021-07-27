# Vagrant Dev VM

Development environment, powered by [Vagrant](https://www.vagrantup.com/) and configured by [Ansible](https://www.ansible.com/), to play with different container runtimes and tooling.

Thanks to [Roboxes](https://roboxes.org/) for the Virtual Machine [images](https://app.vagrantup.com/roboxes).

Supported hypervisors: vmware_desktop, virtualbox, parallels, libvirt, hyperv.

## environments

container host options:

* Podman and buildah + [podman-compose](https://github.com/containers/podman-compose) on CentOS
* Docker + [Compose](https://docs.docker.com/compose/) on Ubuntu
* Others?

The ansible role also installs [Cockpit](https://cockpit-project.org/) for easy web admin.

## use

1) Edit the `Vagrantfile` to set the desired OS.

2) In a shell, start the VM and login to it. The port forwards do not always work for me so I set them.

   A) `vagrant up`

   B) `vagrant ssh -- -L 9191:127.0.0.1:9090 -L 3131:127.0.0.1:3000`

3) Run one of the `/home/vagrant/start-mpc-*.sh` scripts, or you can `cd /vagrant/ && make dev`

4) On your desktop open the [app](http://localhost:3131/)

5) running `vagrant rsync-auto` in another shell on your host is also useful (if you use HyperV).
