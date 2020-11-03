# MPContainer in Kubernetes

## Music Volume

We need to have some config that will point to where the music is.

Copy the yaml config files you need for your environment into the kubernetes dir, make sure the files are prefixed with `pv-` so they will be ignored by Git.

```shell
cp kubernetes/examples/pv-claim.yaml kubernetes/pv-claim.yaml
cp kubernetes/examples/pv-store-dev.yaml kubernetes/pv-store-dev.yaml
```

See [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) documentation for more information.

## Ingress

You can optionaly run an Ingress in front of haproxy.

You will need an ingress controller running in your cluster, such as nginx:

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/baremetal/deploy.yaml
```

You can then utilise the provided configuration.

```
cp kubernetes/examples/ingress.yaml kubernetes/ingress.yaml
```


## Run

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
kubectl -n musicplayer delete all --all
```
