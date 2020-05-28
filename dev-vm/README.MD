# dev-vm

Development environments, powered by [Vagrant](https://www.vagrantup.com/), to play with different container runtimes and tooling.

Thanks to [Roboxes](https://roboxes.org/) for the Virtual Machine images.


## environments

A work in progess as I learn and experiment with different stacks.

Single container host:

* Podman + [podman-compose](https://github.com/containers/podman-compose)
* Docker + [Compose](https://docs.docker.com/compose/)

Cluster (single node for dev):

* Docker + [Swarm](https://docs.docker.com/engine/swarm/)
* Docker + [Kubernetes](https://kubernetes.io/)


## use

1) Edit the Vagrantfile to set the desired OS/Stack. So far the Ansible `playbook.yml` can handle these:

   * `generic/centos8`
   * `generic/ubuntu1804`

2) In a shell, start the system.

   * `vagrant up`
   * `vagrant ssh -- -L 9191:127.0.0.1:9090 -L 3131:127.0.0.1:3000`

   The port forwards do not always work for me so I set them.

3) Run one of the "/home/vagrant/start-mpc-*.sh" scripts.

3) From a shell on your host `vagrant rsync-auto` is useful.
