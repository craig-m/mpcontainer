# dev-vm

Development environments, powered by [Vagrant](https://www.vagrantup.com/), to play with different container runtimes and tooling. 

Thanks to [Roboxes](https://roboxes.org/) for the Virtual Machine images.


### Environments

Single container host:

* Podman + [podman-compose](https://github.com/containers/podman-compose)
* Docker + [Compose](https://docs.docker.com/compose/)

Cluser Dev (single node):

* [MicroK8s](https://github.com/ubuntu/microk8s)

Cluster:

* Docker + [Swarm](https://docs.docker.com/engine/swarm/)
* Docker + [Kubernetes](https://kubernetes.io/)


# use

Edit the Vagrantfile to the desired OS/Stack. So far the Ansible `playbook.yml` can handle these:

* `generic/centos8`
* `generic/ubuntu1804`

And then start the system:

```
vagrant up
vagrant ssh
```

Then run one of the start-mpc-*.sh scripts.

In a shell on your host system `vagrant rsync-auto` is useful.