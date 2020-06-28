# Readme

The Linode Kubernetes Engine ([LKE](https://www.linode.com/products/kubernetes/)) is a fully-managed container orchestration engine.

We can use Terraform to provision LKE, and storage for the cluster.

* https://github.com/terraform-providers/terraform-provider-linode
* https://www.linode.com/community/questions/17611/the-linode-kubernetes-module-for-terraform

## admin container

Build the container, setup is done by Ansible.

```shell
docker build -t mpcontainer-sysadmin:latest .
```

Start the container:

```shell
docker run -it \
    --mount type=bind,source="$(pwd)"/terraform,target=/opt/terraform \
    --mount type=bind,source="$(pwd)"/../kubernetes,target=/opt/kubernetes \
    mpcontainer-sysadmin /bin/bash
```

You can run `terraform`, `kubectl`, `linode-cli` and `ansible` from this container.

## Use

See the `deploy.md` document for use.
