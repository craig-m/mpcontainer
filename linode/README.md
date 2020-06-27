# Readme

The Linode Kubernetes Engine ([LKE](https://www.linode.com/products/kubernetes/)) is a fully-managed container orchestration engine.

We can use Terraform to provision LKE, and storage for the cluster.

* https://github.com/terraform-providers/terraform-provider-linode
* https://www.linode.com/community/questions/17611/the-linode-kubernetes-module-for-terraform

## admin container

Run `terraform`, `kubectl` and `linode-cli` from a container on our desktop.

Start the container:

```shell
docker build -t mpcontainer-sysadmin:latest .
docker run -it mpcontainer-sysadmin /bin/bash
```

## Use

To do.