variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
}

locals {
  db_map = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "db" {
  for_each = local.db_map

  name     = each.key
  hostname = each.key

  zone = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true

    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${local.ssh_public_key}"
  }
}
