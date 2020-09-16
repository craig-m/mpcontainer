provider "linode" {
   token = var.token
}

resource "linode_stackscript" "mpc_vm_stackscript" {
   label = "mpc_vm_stackscript"
   description = "mpcontainer vm hosting"
   script = file("${path.module}/assets/stackscript.sh")
   images = ["linode/ubuntu18.04"]
   is_public = "false"
   rev_note = "initial version"
}


resource "random_uuid" "vmtrack" { }

resource "random_password" "my_root_password" {
   length = 25
   special = false
   min_upper = 5
   min_lower = 5
   min_numeric = 5
}

resource "random_password" "my_user_password" {
   length = 25
   special = false
   min_upper = 5
   min_lower = 5
   min_numeric = 5
}

resource "linode_instance" "vm1" {
   image             = "linode/ubuntu18.04"
   label             = "mpcontainer"
   group             = "terraform-vm"
   region            = var.region
   tags              = ["prod-vm"]
   count             = "1"
   type              = "g6-nanode-1"
   stackscript_id    = linode_stackscript.mpc_vm_stackscript.id
   stackscript_data = {
      "adduser" = var.stackscript_data["adduser"]
      "userpass" = random_password.my_user_password.result
      "uuidvar" = random_uuid.vmtrack.result
   }
   authorized_keys   = var.authorized_keys
   root_pass         = random_password.my_root_password.result
}

