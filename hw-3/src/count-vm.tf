variable "web_vm" {
  description = "Web VMs resources"
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

resource "yandex_compute_instance" "web" {
  count = 2

  name     = "web-${count.index + 1}"
  hostname = "web${count.index + 1}"

  zone = var.default_zone

  resources {
    cores  = var.web_vm.cores
    memory = var.web_vm.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.id
      size     = var.web_vm.boot_disk_gb
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

  # web должны создаться после db
  depends_on = [yandex_compute_instance.db]
}
