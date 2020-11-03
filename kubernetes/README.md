# MPContainer in Kubernetes

## Configure Music Volume

We need to have some config that will point to where the music is.

Copy the yaml config files you need for your environment into the kubernetes dir, make sure the files are prefixed with `pv-` so they will be ignored by Git.

```shell
cp kubernetes/examples/pv-claim-nfs.yaml kubernetes/pv-claim-nfs.yaml
cp kubernetes/examples/pv-store-nfs.yaml kubernetes/pv-store-nfs.yaml
```

You will then need to update the values in `pv-store-nfs.yaml`

This example uses NFS, for local storage use `-dev`. If you are using NFS your Nodes will also need NFS tools to be able to mount the volume:

```shell
apt install -y nfs-common
```

See [persistent volumes][docs-pv] documentation for more information.

## Configure Ingress (optional)

You can optionaly run an Ingress in front of HAProxy.

You will need an [ingress controller][docs-ingress-controller] running in your cluster, such as [nginx][nginx-ingress], which could be installed such as:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml
```

You can then copy in the provided configuration:

```shell
cp kubernetes/examples/ingress.yaml kubernetes/ingress.yaml
```

See [ingress][docs-ingress] documentation for more information.

## Deploy

After copying and editing what you need from `/kubernetes/examples/` to `/kubernetes/` for the configuration of your music volume you can apply the Kubernetes manifests to bring up MPContainer:

```shell
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f ./kubernetes/
```

Check on it:

```shell
kubectl -n musicplayer get deployments,pods,svc,ep,pv
```

Access the service for testing with a command like:

```shell
kubectl -n musicplayer port-forward frontend-6bc9c5dd68-frw8g 3000:3000
```

## Tearing Down

```shell
kubectl delete -f kubernetes/
```

_or_

```shell
kubectl -n musicplayer delete all --all
```

[docs-pv]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
[docs-ingress-controller]: https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/
[docs-ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
[nginx-ingress]: https://kubernetes.github.io/ingress-nginx/


