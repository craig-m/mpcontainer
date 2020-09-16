#!/bin/bash

echo "running Terraform"

terraform validate

terraform init

TF_LOG=debug
terraform plan

terraform apply \
    -var "token=$(grep token ~/.config/linode-cli | awk '{print $3}')" \
    -auto-approve

echo "done"