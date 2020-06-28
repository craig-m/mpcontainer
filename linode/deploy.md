# Linode

Notes on deploying MPContainer to LKE.

Prerequisites:

* Deploy a LKE.
* Have your `kubectl` talking to your LKE.

See the [docs](https://www.linode.com/docs/kubernetes/deploy-and-manage-lke-cluster-with-api-a-tutorial/) and then continue.

## create

If you are inside the container `cd /opt/` and then carry on.

create the MPContainer name space:

```shell
kubectl apply -f ./kubernetes/namespace.yaml
```

### storage

apply block store driver:

```shell
kubectl apply -f https://raw.githubusercontent.com/linode/linode-blockstorage-csi-driver/master/pkg/linode-bs/deploy/releases/linode-blockstorage-csi-driver-v0.1.6.yaml
```

create the volume:

```shell
kubectl create -f ./kubernetes/examples/pv-store-linode.yaml
```

apply volume claim:

```shell
kubectl apply -f ./kubernetes/examples/pv-claim-linode.yaml
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
