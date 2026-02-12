variable "ssh_user" {
  type        = string
  description = "SSH user for metadata ssh-keys"
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "/home/netology/.ssh/id_rsa.pub"
}

locals {
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
}
