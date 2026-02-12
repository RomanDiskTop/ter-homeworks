variable "storage_vm" {
  type = object({
    cores        = number
    memory       = number
    boot_disk_gb = number
  })
  default = {
    cores        = 2
    memory       = 2
    boot_disk_gb = 10
  }
}

resource "yandex_compute_disk" "storage_disk" {
  count = 3

  name = "storage-disk-${count.index + 1}"
  zone = var.default_zone
  size = 1
}

resource "yandex_compute_instance" "storage" {
  name     = "storage"
  hostname = "storage"

  zone = var.default_zone

  resources {
    cores  = var.storage_vm.cores
    memory = var.storage_vm.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.id
      size     = var.storage_vm.boot_disk_gb
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id     = secondary_disk.value.id
      auto_delete = true
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${local.ssh_public_key}"
  }
}
