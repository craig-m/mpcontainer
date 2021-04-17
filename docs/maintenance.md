# Maintaining

What needs to routinly be updated:

* Each Dockerfile base image version, for example `FROM haproxy:2.2.13-alpine`.

* The docker-compose.yaml the `cache_from:` versions.

* Vagrant-dev-vm/, in the Vagrantfile:
  * The `config.vm.box_version = "3.2.16"` for the boxes
  * A minumum version of vagrant with `Vagrant.require_version ">= 2.2.14"`

* Container-web/
  * versions of Jquery, bootstrap, popper.js etc in `package.json`.

* Linode terraform
  * In LKE `k8s_version = "1.18"`
  * In VM the Image, eg `["linode/ubuntu18.04"]`
