#
# MPContainer Terraform for LKE
#

provider "linode" {
  token = var.token
}

resource "linode_lke_cluster" "my-cluster" {
    label       = "mpcontainer-cluster"
    k8s_version = "1.17"
    region      = "ap-southeast"
    tags        = ["prod"]

    pool {
        type  = "g6-standard-2"
        count = 1
    }
}


// Export this cluster's attributes
output "kubeconfig" {
   value = linode_lke_cluster.my-cluster.kubeconfig
}

output "api_endpoints" {
   value = linode_lke_cluster.my-cluster.api_endpoints
}

output "status" {
   value = linode_lke_cluster.my-cluster.status
}

output "id" {
   value = linode_lke_cluster.my-cluster.id
}

output "pool" {
   value = linode_lke_cluster.my-cluster.pool
}
