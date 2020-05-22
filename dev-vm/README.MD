# dev-vm

Development environments, powered by [Vagrant](https://www.vagrantup.com/), to play with different container runtimes and tooling.

Thanks to [Roboxes](https://roboxes.org/) for the Virtual Machine images.


## environments

A work in progess as I learn and experiment with different stacks.

Single container host:

* Podman + [podman-compose](https://github.com/containers/podman-compose)
* Docker + [Compose](https://docs.docker.com/compose/)

Cluster:

* Docker + [Swarm](https://docs.docker.com/engine/swarm/)
* Docker + [Kubernetes](https://kubernetes.io/)


### use

1) Edit the Vagrantfile to the desired OS/Stack. 

So far the Ansible `playbook.yml` can handle these:

* `generic/centos8`
* `generic/ubuntu1804`

2) start the system:

```
vagrant up
vagrant ssh
```

3) Run one of the /home/vagrant/start-mpc-*.sh scripts in.

3) In a shell on your host system `vagrant rsync-auto` is useful.
