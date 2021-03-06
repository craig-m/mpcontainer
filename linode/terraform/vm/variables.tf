variable "token" {}

variable "region" {
    description = "The default Linode region to deploy the infrastructure"
    default = "ap-southeast"
}

variable "authorized_keys" {
    description = "The Public id_rsa.pub key used for secure SSH connections"
    default = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUuOufqxeI7fVUCcIbnq0m6jYZ3Y5gmsLPHJu/1gNpS1jbb4FyOrp7bkxeQIsHcPTrCX67fzfKAQVM6W7LtrIvKE1dZGQrbTiaYOiKaSPiRKuyqnVeV+5JsPkru4PE3WvQ5vHlhtyjr0B219eSDeZsjq5eL4ZxDEjp8+eJ+v2ZwX88ntwCniK/Dw/XOuqshHaKPBW7Me1AEYfMervoikHZTi+rTrBo0YUygJ5ZuIxOAKfxT8Lz4HXM5rE4b4l+d+xDfH2IdmTALxEtHzHf+Mcuu9MtEzQQbVY35ckhHfUZ5L3p4rPR0DD8Cmb/ir5R+NVmhXFnPn3Oy39ekGjdrOOX9l5QnGHobWe1mCqf3PJg34bHCuhnkKq8tWG9XhInSsjgtNyv9/Sehx/GPYY1K1Q6D/L/XEeXASwbJI+mDjQ0W5vzcGvC8jbBwcdSu2GdIYdkdkL4DQBo3sAtYEU14TPt84QaNBv9XBts8j4t6vyz3z1lmzGcxkOmhBTiJnpO0ONK9IeJai8ZA+HULraWkFI5Y5UfQVEKCvT3+3/FS135nx8wLAfiBgKNEWkjsNAhc0smVRTvh3qSspZ4TSRMhq6DtHOkXUSLB+GkDNheuwwjKXAWDqkZKVhGtE52kuJs1G4yFB0MMEL8nGeQsv+n2yTRu5fuFa39QnbAtT44HaxhgQ== c"]
}

variable "stackscript_data" {
  description = "Map of required StackScript UDF data."
  type = map
  default = {}
}