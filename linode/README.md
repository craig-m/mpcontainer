# Readme

The [Linode](https://www.linode.com/) Kubernetes Engine ([LKE](https://www.linode.com/products/kubernetes/)) is a fully-managed container orchestration engine. Linode also offer great hosting for linux virtual machines.

We can use [Terraform](https://www.terraform.io/) to provision an environment in Linode for MPContainer, on LKE or in a VM.

## admin container

Our admin tools (Terraform etc) are in this container.

To build and start the admin container:

```shell
./start-container.sh
```

When finished just type `exit` to stop the container.

### Use

Get a [Token](https://cloud.linode.com/profile/tokens) from the web panel then, on the mpcontainer-sysadmin shell, login to Linode and see what version of Kubernetes are available:

```shell
linode-cli configure
```

Note: you do NOT want to publish this image, especially after logging into your Linode account :)

From here we can create infrastructure and deploy MPContainer onto it.

---

## Terraform

* https://github.com/terraform-providers/terraform-provider-linode
* https://www.linode.com/community/questions/17611/the-linode-kubernetes-module-for-terraform
* https://www.terraform.io/docs/providers/linode/r/lke_cluster.html
* https://developers.linode.com/api/v4/

### setup

Get the plugin

```shell
cd /opt/terraform/lke
terraform init
```

### use

See what the plan will do (no changes):

```
terraform plan
```

deploy the plan (makes changes!):

```
terraform apply -var "token=$(grep token ~/.config/linode-cli | awk '{print $3}')"
```

### setup kubectl

We need to connect kubectl to the lke.

Get the config with terraform:

```
export KUBE_VAR=`terraform output kubeconfig`
echo $KUBE_VAR | base64 -d > ~/lke-mpc.yaml
export KUBECONFIG=~/lke-mpc.yaml
```

test it:

```
kubectl config get-contexts
kubectl get nodes
```

---

## Kubernetes

* https://www.linode.com/docs/kubernetes/deploy-and-manage-lke-cluster-with-api-a-tutorial/

### create

create the MPContainer name space:

```shell
cd /opt/
kubectl apply -f ./kubernetes/namespace.yaml
```

#### storage

apply block store driver:

```shell
kubectl apply -f https://raw.githubusercontent.com/linode/linode-blockstorage-csi-driver/master/pkg/linode-bs/deploy/releases/linode-blockstorage-csi-driver-v0.1.6.yaml
```

create the volume:

todo: Fix. Why is mine broken?!

```shell
kubectl create -f ./kubernetes/examples/pv-store-linode.yaml
```

apply volume claim:

```shell
kubectl create -f ./kubernetes/examples/pv-claim-linode.yaml
```

### application

deploy the apps:

```shell
kubectl apply -f ./kubernetes/
```

get status:

```shell
kubectl -n musicplayer get deployments,pods,svc,ep,pv,pvc
```

### let traffic in

let traffic in with a Node Balancer.

## teardown

Remove PVC:

```shell
kubectl -n musicplayer delete pvc music-claim
```
