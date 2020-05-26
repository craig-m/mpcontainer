#!/bin/bash

# Setup MicroK8 https://microk8s.io/

# confirm
echo -e "\n Setup MicroK8 env? yes / no \n"
while true; do
    read -p " " yn
    case $yn in
        [Yy]* ) echo 'carrying on'; break;;
        [Nn]* ) echo 'exiting'; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sudo snap install microk8s --classic --channel=1.18/stable
sudo microk8s status --wait-ready
sudo microk8s enable dns dashboard registry
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

sudo microk8s kubectl get nodes
sudo microk8s kubectl get services

# shell in new group
sudo su -l vagrant

cat << EOF > /home/vagrant/start-microk8.sh
#!/bin/bash
alias kubectl='microk8s kubectl'
cd /vagrant || exit 1;
# kubectl apply -f kubernetes/examples/nginx.yaml
# kubectl -n ingress-nginx get svc
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f ./kubernetes/
kubectl -n musicplayer get svc
kubectl -n musicplayer get pods
EOF
